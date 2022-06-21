extends Slottable
class_name Skill

enum SKILL_TAGS { PHYSICAL, MAGIC, ATTACK, CAST_ON_SELF }

signal play_animation

var attacker
var target

export (float) var base_cooldown
export (String) var skill_name
export (Texture) var skill_icon

# Tags
export (Array, SKILL_TAGS) var tags

var level = 1
var cooldown
var auto_cooldown
var manual_cooldown
var on_cd = false

var locked = false
var equipped = true
export var level_required = 0

func _ready():
	slottable_name = skill_name
	cooldown = base_cooldown
	auto_cooldown = base_cooldown
	icon = skill_icon

func description():
	pass

func cast_on_self():
	for tag in tags:
		if tag == SKILL_TAGS.CAST_ON_SELF:
			return true
	return false

func get_cooldown_timer():
	return $Cooldown

func set_level(_level):
	level = _level
	check_level()

func levelup():
	level += 1
	check_level()

func check_level():
	if level >= level_required:
		unlock()
		equip()

func equip():
	equipped = true

func unequip():
	equipped = false

func lock():
	equipped = false
	locked = true;

func unlock():
	locked = false

func update_cooldowns(auto_combat):
	# Apply cdr stat in the future
	if attacker != null:
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
	if !on_cd and !locked and equipped:
		use_skill()
		return skill_name
	else:
		return null

func _on_Cooldown_timeout():
	on_cd = false

func play_animation(animation):
	emit_signal("play_animation", animation)
