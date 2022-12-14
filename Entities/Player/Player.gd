extends Entity
class_name Player

signal items_changed
signal exp_changed

const save_path = "user://player.tscn"

const skill_slot_unlock_levels = [0, 5, 30, 75, 150, 250]

const trait_point_levels = [20, 40, 60, 80]

const save_properties = ["level", "experience"]

export var experience = 0 setget set_exp

func _ready():
	Saver.save_on_exit(self)
	self.load()
	CombatProcessor.connect("entered_auto_combat", self, "_on_enter_auto_combat")
	CombatProcessor.connect("entered_manual_combat", self, "_on_enter_manual_combat")
	LootManager.connect("item_acquired", self, "_on_item_acquired")
	set_level(level)
	if CraftingManager.debug:
		set_level(500)
	play_animation("run")
	ready = true
	update_stats()
	set_weapon_sprites()
	set_armor_sprites()

func play_animation(_animation):
	if (_animation == "melee" and enemy != null):
		go_to_enemy()
		return
	if (_animation == "hurt" and animation == "attack"):
		return
	$AnimationPlayer.play("RESET")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play(_animation)

func set_exp(value):
	experience = value
	check_experience()
	emit_signal("exp_changed")

func check_experience():
	if experience >= total_exp_required():
		level_up()
		check_experience()

func total_exp_required(_level = level + 1):
	return int(10 * pow(_level, 2.5))

func next_level_exp_required():
	return total_exp_required(level + 1) - total_exp_required(level)

func current_level_exp():
	return experience - total_exp_required(level)

func level_up():
	.level_up()
	GlobalResources.gain_gr(GlobalResources.GR.SKILL_POINT, 1) # TEMP
	if level in trait_point_levels:
		GlobalResources.gain_gr(GlobalResources.GR.TRAIT_POINT, 1) # TEMP

func calculate_stats():
	.calculate_stats()
	update_skill_slots()
	update_skill_cooldowns(CombatProcessor.auto_combat)

func apply_spec_attributes():
	for spec in $Specializations.get_children():
		if spec.active:
			spec.on_calculate_attributes(attributes)

func update_skill_slots():
	skill_slots = 0
	for lvl in skill_slot_unlock_levels:
		if lvl <= level:
			skill_slots += 1
		else:
			break

func next_action(var override = false):
	if CombatProcessor.auto_combat or override:
		.next_action()

func enter_combat():
	.enter_combat()
	set_hp(stats.max_hp)
	set_target(CombatProcessor.Monster)
	if !CombatProcessor.auto_combat:
		next_action_ready = true

func exit_combat():
	.exit_combat()
	if !dead:
		speed_scale = 1
		play_animation("run")

func get_weapons():
	var weapons = []
	for item in get_items():
		if item.type == CraftingManager.ITEM_TYPE.WEAPON:
			weapons.append(item)
	while weapons.size() < 2:
		weapons.append(null)
	return weapons

func get_armor():
	var armor = []
	for item in get_items():
		if item.type == CraftingManager.ITEM_TYPE.ARMOR:
			armor.append(item)
	return armor

func set_weapon_sprites():
	var weapons = get_weapons()
	$Weapon1.set_slottable(weapons[0])
	$Weapon2.set_slottable(weapons[1])

func set_armor_sprites():
	for i in $Armor.get_children():
		for j in i.get_children():
			j.hide()
	var armor = get_armor()
	for piece in armor:
		var paths = piece.get_sprite_paths()
		for path in paths:
			if !has_node(path[0]):
				continue
			var node = get_node(path[0])
			node.show()
			node.modulate = path[1]

func equip_item(item : Item):
	.equip_item(item)
	emit_signal("items_changed")

func unequip_item(item : Item):
	.unequip_item(item)
	LootManager.get_item(item)
	emit_signal("items_changed")

func get_skills_container():
	return $Skills

func _on_enter_manual_combat():
	update_skill_cooldowns(CombatProcessor.auto_combat)
	stats.action_time = stats.action_time_manual

func _on_enter_auto_combat():
	update_skill_cooldowns(CombatProcessor.auto_combat)
	stats.action_time = stats.action_time_auto
	if $ActionTimer.time_left == 0:
		start_action_timer()

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.EXPERIENCE:
		get_experience(item.quantity)
		item.queue_free()

func get_experience(_exp):
	self.experience += _exp

func _on_Entity_animation_finished():
	._on_Entity_animation_finished()
	if animation == "die":
		fake_die()

func fake_die():
	visible = false

func fake_respawn():
	dead = false
	can_be_attacked = true
	visible = true
	set_hp(stats["max_hp"])
	if CombatProcessor.in_combat:
		play_animation("idle")
	else:
		play_animation("run")

func load():
	if ResourceLoader.exists(save_path):
		var saved_scene = load(save_path)
		var instance = saved_scene.instance()
		for prop in save_properties:
			set(prop, instance.get(prop))
		for item in instance.get_items():
			item.load()
			instance.remove_item(item)
			equip_item(item)
		for skill in get_skills():
			for iskill in instance.get_skills():
				if skill.skill_name == iskill.skill_name:
					skill.copy(iskill)
		for spec in get_all_specs():
			for ispec in instance.get_all_specs():
				if spec.specialization_name == ispec.specialization_name:
					spec.copy(ispec)
		instance.queue_free()

func save_and_exit():
	for effect in $Effects.get_children():
		effect.expire()
	for dn in $DamageNumberManager.get_children():
		dn.queue_free()
	Saver.save_scene(self, save_path)
