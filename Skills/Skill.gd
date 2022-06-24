extends Slottable
class_name Skill

enum SKILL_TAGS { PHYSICAL, MAGIC, ATTACK, CAST_ON_SELF }
enum UPGRADE_REQS { LOTUS, SKILL_POINT }

const req_type_vars = {
	UPGRADE_REQS.LOTUS : "SKILL_LOTUSES",
	UPGRADE_REQS.SKILL_POINT : "SKILL_POINTS"
}

signal play_animation
signal skill_updated

var attacker setget set_attacker
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

func set_attacker(new_value):
	attacker = new_value
	if attacker != null:
		attacker.connect("level_changed", self, "check_level")
		connect("play_animation", attacker, "play_animation")
		if cast_on_self():
			target = attacker
	check_level()

func description():
	pass

func cast_on_self():
	for tag in tags:
		if tag == SKILL_TAGS.CAST_ON_SELF:
			return true
	return false

func get_cooldown_timer():
	return $Cooldown

func get_upgrade_reqs():
	var skill_points = int(level / 3) + 1
	var lotuses = 0
	if level >= 10:
		lotuses = level * 6
	elif level >= 5:
		lotuses = level * 4
	else:
		lotuses = 0
	return {
		UPGRADE_REQS.LOTUS : lotuses,
		UPGRADE_REQS.SKILL_POINT : skill_points
	}

func try_to_upgrade():
	var reqs = get_upgrade_reqs()
	for req in reqs:
		if reqs[req] > GlobalResources.get(req_type_vars[req]):
			return
	for req in reqs:
		GlobalResources.set(req_type_vars[req], GlobalResources.get(req_type_vars[req]) - reqs[req])
	level_up()

func set_level(_level):
	level = _level
	emit_signal("skill_updated")

func level_up():
	level += 1
	emit_signal("skill_updated")

func check_level():
	print("Checking level : " + str(self) + " : "+ str(attacker))
	if attacker == null:
		return
	if attacker.level >= level_required:
		unlock()
		equip()
	else:
		lock()
		unequip()
	emit_signal("skill_updated")

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
