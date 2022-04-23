extends Node2D
class_name Skill

signal play_animation

var attacker
var target

export (float) var base_cooldown
export (String) var skill_name
export (Texture) var icon
export (String) var description

# Tags
export var phys = false
export var magic = false
export var attack = false
export var cast_on_self = false

var level = 1
var cooldown
var auto_cooldown
var manual_cooldown
var on_cd = false

func _ready():
	cooldown = base_cooldown
	auto_cooldown = base_cooldown

func get_cooldown_timer():
	return $Cooldown

func update_manual_cooldown():
	pass

func set_attacker_and_target():
	pass

func set_level(_level):
	level = _level

func update_cooldowns(auto_combat):
	# Apply cdr stat in the future
	auto_cooldown = base_cooldown
	manual_cooldown = base_cooldown * attacker.stats.manual_cd_multi
	if auto_combat:
		cooldown = auto_cooldown
	else:
		cooldown = manual_cooldown

func use_skill():
	do_skill()
	put_skill_on_cooldown()

func do_skill():
	pass

func put_skill_on_cooldown():
	$Cooldown.start(cooldown)
	on_cd = true

func try_to_use_skill():
	if !on_cd:
		use_skill()
		return skill_name
	else:
		return null

func _on_Cooldown_timeout():
	on_cd = false

func play_animation(animation):
	emit_signal("play_animation", animation)
