extends Entity

signal used_skill

func _ready():
	._ready()
	connect("hp_updated", CombatProcessor, "_on_player_hp_updated")
	connect("used_skill", CombatProcessor, "_on_player_used_skill")
	CombatProcessor.connect("entered_auto_combat", self, "_on_enter_auto_combat")
	CombatProcessor.connect("entered_manual_combat", self, "_on_enter_manual_combat")
	CombatProcessor.connect("manual_use_skill", self, "try_to_use_skill")
	base_stats["action_time_auto"] = 0.3
	base_stats["action_time_manual"] = 0.1
	stats["action_time_auto"] = 0.3
	stats["action_time_manual"] = 0.1
	# TESTING
	set_level(3)
	var Sword = load("res://Items/Sword/Sword.tscn")
	var sword = Sword.instance()
	equip_item(sword)
	# /TESTING
	play("run")
	ready = true
	update_stats()

func next_action():
	if CombatProcessor.auto_combat:
		var skill_name = .next_action()
		if skill_name:
			emit_signal("used_skill", skill_name)

func enter_combat():
	.enter_combat()
	set_target(CombatProcessor.Monster)
	if !CombatProcessor.auto_combat:
		next_action_ready = true

func exit_combat():
	speed_scale = 1
	play_animation("run")

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
