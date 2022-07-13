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
	"manual_cd_multi": 0.33 
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

var stats = base_stats.duplicate()
var attributes = base_attributes.duplicate()

var dead = false
var can_be_attacked = true
var next_action_ready = false
var enemy = null
var level = 0

var yeeting = false
var yeet_x = 15
var yeet_y = -15
const yeet_dist = 20
const yeet_spread = PI

func _ready():
	connect("damage_enemy", CombatProcessor, "damage_enemy")
	connect("apply_effect", CombatProcessor, "apply_effect")
	CombatProcessor.connect("entered_combat", self, "enter_combat")
	CombatProcessor.connect("exited_combat", self, "exit_combat")
	set_skills_attacker()
	calculate_anim_speed()

func _process(delta):
	next_action()
	if yeeting:
		position.x += yeet_x
		position.y += yeet_y
		rotate(0.5)

func set_hp(hp):
	stats.hp = hp
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

# Add check for 2 weapons, signal for equipping / unequipping items
func equip_item(item : Item):
	var weapon_count = 0
	for _item in get_items():
		if _item.type == CraftingManager.ITEM_TYPE.WEAPON:
			weapon_count += 1
		if item.type == _item.type:
			if item.type == CraftingManager.ITEM_TYPE.WEAPON and weapon_count < 2:
				continue
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

# Final for Monster, temp for Player
func update_skill_levels():
	for skill in get_skills():
		skill.set_level(level)

func update_skill_cooldowns(auto_combat):
	for skill in get_skills():
		skill.update_cooldowns(auto_combat)

func update_stats():
	if ready: # No idea why you cant yield(ready), but this works
		reset_stats()
		apply_level_attributes()
		apply_item_stats()
		apply_attribute_stats()
		update_skill_levels()
		if !CombatProcessor.in_combat:
			stats.hp = stats.max_hp
		emit_signal("stats_updated")

func reset_stats():
	for stat in stats:
		stats[stat] = base_stats[stat]
	for at in attributes:
		attributes[at] = base_attributes[at]

func apply_level_attributes():
	for key in per_level.keys():
		attributes[key] += per_level[key] * level

func apply_item_stats():
	for item in get_items():
		item.apply_attributes(attributes)

func apply_attribute_stats():
	stats["phys_damage"] += attributes["power"]
	stats["magic_damage"] += attributes["potency"]
	stats["crit_chance"] += attributes["precision"] * 0.002
	stats["crit_multi"] += attributes["ferocity"] * 0.0015
	stats["phys_protection"] += attributes["armor"]
	stats["magic_protection"] += attributes["occult_aversion"]
	stats["max_hp"] += attributes["vitality"]

func play_animation(animation):
	stop()
	frame = 0
	play(animation)

func enter_combat():
	next_action_ready = false
	calculate_anim_speed()
	play_animation("idle")

func set_target(target): 
	enemy = target
	for skill in get_skills():
		if !skill.cast_on_self():
			skill.target = enemy

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
	if (CombatProcessor.in_combat):
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
	effects_outgoing_damage(damage_info)
	emit_signal("damage_enemy", damage_info)

func apply_crit(damage_info : CombatProcessor.DamageInfo):
	if damage_info.can_crit:
		var roll = Random.rng.randf()
		if roll < stats.crit_chance:
			damage_info.apply_crit(stats.crit_multi)

func items_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	for item in get_items():
		item.on_outgoing_damage(damage_info)

func effects_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	for effect in get_effects():
		effect.on_outgoing_damage(damage_info)

func process_outgoing_effect(effect : Effect):
	# Apply effects / items
	emit_signal("apply_effect", effect)

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
	for item in get_items():
		item.on_incoming_damage(damage_info)

func process_incoming_effect(effect : Effect):
	$Effects.add_child(effect)
	effect.begin()
	emit_signal("effect_applied", effect)

func stats_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	damage_info.phys_damage = damage_info.phys_damage * 100 / (100 + stats.phys_protection)
	damage_info.magic_damage = damage_info.magic_damage * 100 / (100 + stats.magic_protection)

func take_damage_info(damage_info : CombatProcessor.DamageInfo):
	take_damage(damage_info.phys_damage)
	take_damage(damage_info.magic_damage)
	$DamageNumberManager.new_damage_number(damage_info)

func take_damage(damage):
	if damage <= 0:
		return
	if stats.hp - damage > 0:
		set_hp(stats.hp - damage)
	else:
		set_hp(0)
		die()

func heal(amount):
	if (amount <= 0):
		return
	if stats.hp + amount < stats.max_hp:
		set_hp(stats.hp + amount)
	else:
		set_hp(stats.max_hp)

func exit_combat():
	pass

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
		play("idle")
	elif animation == "die":
		emit_signal("despawned")

func yeet():
	yeet_x = sin(Random.rng.randf_range(- yeet_spread / 2, yeet_spread / 2)) * yeet_dist
	yeet_y = - cos(Random.rng.randf_range(- yeet_spread / 2, yeet_spread / 2)) * yeet_dist
	yeeting = true
