extends AnimatedSprite
class_name Entity

var ready = false

signal hp_updated
signal stats_updated
signal level_changed
signal damage_enemy
signal apply_effect
signal effect_applied
signal died
signal despawned

export var base_stats = { 
	"hp": 100.0, 
	"max_hp": 100.0, 
	"phys_damage": 10.0, 
	"magic_damage": 0.0,
	"phys_protection": 20.0, 
	"magic_protection": 20.0, 
	"crit_chance": 0.05, 
	"crit_multi": 1.5, 
	"action_time": 0.3, 
	"action_time_manual": 0.1,
	"action_time_auto": 0.3,
	"manual_cd_multi": 0.33,
	"outgoing_effect_duration_multi": 1.0,
	"outgoing_effect_strength_multi": 1.0,
	"incoming_effect_duration_multi": 1.0,
	"incoming_effect_strength_multi": 1.0,
	"phys_penetration": 0.0,
	"magic_penetration": 0.0,
	"cd_multi": 1.0
}

export var per_level = { 
	"power": 5, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 5, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 5, 
	"occult_aversion": 5, 
	"vitality": 10, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

export var base_attributes = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

export var level = 0

export var skill_slots = 6
var skills_equipped = 0

var stats = base_stats.duplicate()
var attributes = base_attributes.duplicate()

var dead = false
var can_be_attacked = true
var next_action_ready = false
var enemy = null

var combat_pos = Vector2(0, 0)

var yeeting = false
var yeet_x = 1500
var yeet_y = -1500
const yeet_dist = 2000
const yeet_spread = PI

func _ready():
	visible = true
	connect("damage_enemy", CombatProcessor, "damage_enemy")
	connect("apply_effect", CombatProcessor, "apply_effect")
	CombatProcessor.connect("entered_combat", self, "enter_combat")
	CombatProcessor.connect("exited_combat", self, "exit_combat")
	set_skills_attacker()
	calculate_anim_speed()

func _process(delta):
	next_action()
	if yeeting:
		position.x += yeet_x * delta
		position.y += yeet_y * delta
		rotate(50 * delta)

func set_hp(hp):
	stats["hp"] = round(hp)
	emit_signal("hp_updated")

# On creation
func set_level(_level):
	level = _level
	update_stats()
	emit_signal("level_changed")
	return self

func level_up():
	set_level(level + 1)

# On creation
func set_skills_attacker():
	for skill in get_skills():
		skill.attacker = self
	return self

func equip_item(item : Item):
	if item.type == CraftingManager.ITEM_TYPE.WEAPON:
		var weapon_counter = 0
		for _item in get_items():
			if _item.type == CraftingManager.ITEM_TYPE.WEAPON:
				weapon_counter += 1
			if weapon_counter == 2:
				unequip_item(_item)
				break
	elif item.subtype == CraftingManager.ITEM_SUBTYPE.RING:
		var ring_counter = 0
		for _item in get_items():
			if _item.subtype == CraftingManager.ITEM_SUBTYPE.RING:
				ring_counter += 1
			if ring_counter == 2:
				unequip_item(_item)
				break
	else:
		for _item in get_items():
			if _item.subtype == item.subtype:
				unequip_item(_item)
				break
	$Items.add_child(item)
	item.connect("slottable_updated", self, "update_stats")
	update_stats()

func unequip_item(item : Item):
	$Items.remove_child(item)
	item.disconnect("slottable_updated", self, "update_stats")
	update_stats()
	LootManager.get_item(item)

func try_equip_skill(skill, value):
	if value and can_equip_skill() and !skill.equipped:
		skill.equipped(true)
		skills_equipped += 1
	elif skill.equipped and !value:
		skill.equipped(false)
		skills_equipped -= 1

func can_equip_skill():
	return skills_equipped < skill_slots

func update_skill_levels():
	pass

func update_skill_cooldowns(auto_combat):
	for skill in get_skills():
		skill.update_cooldowns(auto_combat, stats["cd_multi"])

func update_stats():
	if ready:
		var hp = stats["hp"]
		calculate_stats()
		if !CombatProcessor.in_combat:
			stats["hp"] = stats.max_hp
		else:
			stats["hp"] = hp
		emit_signal("stats_updated")

func calculate_stats():
	reset_stats()
	apply_level_attributes()
	apply_item_attributes()
	apply_effect_attributes()
	apply_attribute_stats()
	update_skill_levels()

func reset_stats():
	for stat in stats:
		stats[stat] = base_stats[stat]
	for at in attributes:
		attributes[at] = base_attributes[at]

func apply_level_attributes():
	for key in per_level.keys():
		attributes[key] += per_level[key] * level

func apply_item_attributes():
	for item in get_items():
		item.apply_attributes(attributes)

func apply_effect_attributes():
	for effect in get_effects():
		if !effect.expired:
			effect.apply_attributes(attributes)

func apply_attribute_stats():
	stats["phys_damage"] += attributes["power"]
	stats["magic_damage"] += attributes["potency"]
	if attributes["precision"] < 75:
		stats["crit_chance"] += attributes["precision"] * 0.002
	else:
		stats["crit_chance"] += sqrt(attributes["precision"] * 0.0003)
	stats["crit_multi"] += attributes["ferocity"] * 0.002
	stats["phys_protection"] += attributes["armor"]
	stats["magic_protection"] += attributes["occult_aversion"]
	apply_vitality()
	stats["outgoing_effect_duration_multi"] += attributes["mastery"] * 0.002
	stats["outgoing_effect_strength_multi"] += attributes["expertise"] * 0.002
	stats["incoming_effect_duration_multi"] += 1000.0 / (1000 + attributes["toughess"]) - 1
	stats["phys_penetration"] += attributes["penetration"]
	stats["magic_penetration"] += attributes["magic_penetration"]
	stats["cd_multi"] += 25.0 / sqrt(attributes["dexterity"] + 900) - 1 + 1.0/6

func apply_vitality():
	stats["max_hp"] += attributes["vitality"] * 4

func play_animation(_animation):
	if (_animation == "melee" and enemy != null):
		go_to_enemy()
		return
	if (_animation == "hurt" and animation == "attack"):
		return
	stop()
	frame = 0
	play(_animation)

func go_to_enemy():
	var enemy_pos = enemy.combat_pos
	if enemy.combat_pos.y > combat_pos.y:
		enemy_pos += Vector2(0, -70)
	else:
		enemy_pos += Vector2(0, 70)
	$Tween.interpolate_property(
		self,
		"position",
		combat_pos,
		enemy_pos,
		0.2,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT
	)
	$Tween.start()

func go_to_combat_pos():
	$Tween.interpolate_property(
		self,
		"position",
		position,
		combat_pos,
		0.2,
		Tween.TRANS_CIRC,
		Tween.EASE_OUT
	)
	$Tween.start()

func enter_combat():
	next_action_ready = false
	combat_pos = position
	calculate_anim_speed()
	play_animation("idle")

func set_target(target): 
	enemy = target
	for skill in get_skills():
		if !skill.cast_on_self():
			skill.target = enemy
	if enemy != null:
		enemy.connect("died", self, "_on_enemy_died")

func _on_enemy_died():
	set_target(null)

func get_action_timer():
	return $ActionTimer

func get_skills():
	return $Skills.get_children()

func get_effects():
	return $Effects.get_children()

func get_items():
	return $Items.get_children()

func next_action():
	var _skill = null
	if CombatProcessor.in_combat:
		if !dead and enemy != null and enemy.can_be_attacked and next_action_ready:
			for skill in get_skills():
				_skill = try_to_use_skill(skill)
				if _skill:
					break
		if !next_action_ready and $ActionTimer.get_time_left() == 0:
			start_action_timer()
	return _skill

func try_to_use_skill(skill):
	var _skill = null
	if next_action_ready and !dead: 
		_skill = skill.try_to_use_skill()
		if _skill:
			start_action_timer()
	return _skill

func process_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	apply_crit(damage_info)
	items_outgoing_damage(damage_info)
	stats_outgoing_damage(damage_info)
	effects_outgoing_damage(damage_info)
	for effect in damage_info.effects:
		apply_stats_to_effect(effect)
	emit_signal("damage_enemy", damage_info)

func apply_crit(damage_info : CombatProcessor.DamageInfo):
	if damage_info.can_crit:
		var roll = Random.rng.randf()
		if roll < stats.crit_chance:
			damage_info.apply_crit(stats.crit_multi)

func items_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	for item in get_items():
		item.on_outgoing_damage(damage_info)

func stats_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	damage_info.phys_pen(stats["phys_penetration"])
	damage_info.magic_pen(stats["magic_penetration"])

func effects_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	for effect in get_effects():
		effect.on_outgoing_damage(damage_info)

func process_outgoing_effect(effect : Effect):
	apply_stats_to_effect(effect)
	emit_signal("apply_effect", effect)

func apply_stats_to_effect(effect : Effect):
	effect.process_duration_multi(stats["outgoing_effect_duration_multi"])
	effect.process_strength_multi(stats["outgoing_effect_strength_multi"])

func process_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	items_incoming_damage(damage_info)
	effects_incoming_damage(damage_info)
	for effect in damage_info.effects:
		process_incoming_effect(effect)
	stats_incoming_damage(damage_info)
	take_damage_info(damage_info)

func items_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	for item in get_items():
		item.on_incoming_damage(damage_info)

func effects_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	for effect in get_effects():
		effect.on_incoming_damage(damage_info)

func process_incoming_effect(effect : Effect):
	effect.process_duration_multi(stats["incoming_effect_duration_multi"])
	effect.process_strength_multi(stats["incoming_effect_strength_multi"])
	$Effects.add_child(effect)
	effect.connect("effect_expired", self, "update_stats")
	effect.begin()
	emit_signal("effect_applied", effect)
	update_stats()

func stats_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	damage_info.phys_damage = int(damage_info.phys_damage * 15 / sqrt(max(0, stats.phys_protection - damage_info.phys_pen) + 225))
	damage_info.magic_damage = int(damage_info.magic_damage * 15 / sqrt(max(0, stats.magic_protection - damage_info.magic_pen) + 225))

func take_damage_info(damage_info : CombatProcessor.DamageInfo):
	play_animation("hurt")
	take_damage(damage_info.phys_damage)
	take_damage(damage_info.magic_damage)
	$DamageNumberManager.new_damage_number(damage_info)
#	var combat_log = name + " took " + str(damage_info.phys_damage + damage_info.magic_damage)
#	if damage_info.is_crit:
#		combat_log += " (Critical)"
#	combat_log += " damage."
#	print(combat_log)

func take_damage(damage):
	damage = round(damage)
	if damage <= 0:
		return
	if stats["hp"] - damage > 0:
		set_hp(stats["hp"] - damage)
	else:
		set_hp(0)
		die()

func heal(amount):
	if (amount <= 0):
		return
	if stats["hp"] + amount < stats.max_hp:
		set_hp(stats["hp"] + amount)
	else:
		set_hp(stats.max_hp)

func exit_combat():
	if position != combat_pos:
		go_to_combat_pos()

func die():
	dead = true
	can_be_attacked = false
	play("die")
	emit_signal("died")

func calculate_anim_speed():
	if CombatProcessor.in_combat:
		speed_scale = base_stats.action_time / stats.action_time

func start_action_timer():
	next_action_ready = false
	$ActionTimer.start(stats.action_time)

func _on_ActionTimer_timeout():
	next_action_ready = true

func _on_Entity_animation_finished():
	if animation == "attack" or animation == "attack_alt":
		go_to_combat_pos()
		play("idle")
	elif animation == "hurt":
		play("idle")
	elif animation == "die":
		yield(get_tree().create_timer(1), "timeout")
		on_die_finished()

func on_die_finished():
		emit_signal("despawned")

func yeet():
	yeet_x = sin(Random.rng.randf_range(- yeet_spread / 2, yeet_spread / 2)) * yeet_dist
	yeet_y = - cos(Random.rng.randf_range(- yeet_spread / 2, yeet_spread / 2)) * yeet_dist
	yeeting = true
