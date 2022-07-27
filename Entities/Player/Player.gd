extends Entity
class_name Player

signal items_changed
signal exp_changed

const save_path = "user://player.tscn"

export var experience = 0 setget set_exp

func _ready():
	if save_path != "":
		Saver.save(self)
	CombatProcessor.connect("entered_auto_combat", self, "_on_enter_auto_combat")
	CombatProcessor.connect("entered_manual_combat", self, "_on_enter_manual_combat")
	CombatProcessor.connect("monster_died", self, "_on_monster_died")
	set_level(level)
	play("run")
	ready = true
	update_stats()

func set_exp(value):
	experience = value
	check_experience()
	emit_signal("exp_changed")

func check_experience():
	if experience >= total_exp_required():
		level_up()
		check_experience()

func total_exp_required(_level = level + 1):
	return int(5 * pow(_level, 2.5))

func next_level_exp_required():
	return total_exp_required(level + 1) - total_exp_required(level)

func current_level_exp():
	return experience - total_exp_required(level)

func level_up():
	.level_up()
	GlobalResources.SKILL_POINTS += 1 # TEMP

func update_skill_levels():
	pass

func update_stats():
	.update_stats()
	update_skill_cooldowns(CombatProcessor.auto_combat)

func next_action():
	if CombatProcessor.auto_combat:
		.next_action()

func enter_combat():
	.enter_combat()
	set_hp(stats.max_hp)
	set_target(CombatProcessor.Monster)
	if !CombatProcessor.auto_combat:
		next_action_ready = true

func exit_combat():
	if !dead:
		speed_scale = 1
		play_animation("run")

func equip_item(item : Item):
	.equip_item(item)
	emit_signal("items_changed")

func unequip_item(item : Item):
	.unequip_item(item)
	emit_signal("items_changed")

func get_skills_container():
	return $Skills

func _on_enter_manual_combat():
	update_skill_cooldowns(CombatProcessor.auto_combat)
	stats.action_time = stats.action_time_manual
	calculate_anim_speed()

func _on_enter_auto_combat():
	update_skill_cooldowns(CombatProcessor.auto_combat)
	stats.action_time = stats.action_time_auto
	if $ActionTimer.time_left == 0:
		start_action_timer()
	calculate_anim_speed()

func _on_monster_died(monster):
	self.experience += monster.get_exp_value()

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
		play("idle")
	else:
		play("run")

func load():
	for item in $Items.get_children():
		item.load()
	update_stats()

func save_and_exit():
	var packed_scene = PackedScene.new()
	for item in Saver.get_all_children($Items):
		item.owner = self
	packed_scene.pack(self)
	ResourceSaver.save(save_path, packed_scene)
