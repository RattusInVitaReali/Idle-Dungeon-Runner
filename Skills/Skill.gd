extends Slottable
class_name Skill

enum SKILL_TAGS { PHYSICAL, MAGIC, ATTACK, CAST_ON_SELF }
enum UPGRADE_REQS { LOTUS, SKILL_POINT }

const BorderTexture1 = preload("res://_Resources/skill_borders/Border3.png")
const BorderTexture2 = preload("res://_Resources/skill_borders/Border4.png")
const BorderTexture3 = preload("res://_Resources/skill_borders/Border5.png")
const BorderTexture4 = preload("res://_Resources/skill_borders/Border6.png")

const req_type_vars = {
	UPGRADE_REQS.LOTUS : "SKILL_LOTUSES",
	UPGRADE_REQS.SKILL_POINT : "SKILL_POINTS"
}

signal play_animation

var attacker setget set_attacker
var target

export (float) var base_cooldown
export (String) var skill_name
export (Texture) var skill_icon

export (bool) var melee = false

# Tags
export (Array, SKILL_TAGS) var tags

var border_texture = BorderTexture1

export var level = 1 setget set_level

var cooldown
var auto_cooldown
var manual_cooldown
var on_cd = false

export var equipped = false

func _ready():
	slottable_name = skill_name
	cooldown = base_cooldown
	auto_cooldown = base_cooldown
	icon = skill_icon
	locked = true # Why is this needed wtf?

func set_attacker(new_value):
	attacker = new_value
	if attacker != null:
		attacker.connect("level_changed", self, "try_unlock")
		connect("play_animation", attacker, "play_animation")
		if cast_on_self():
			target = attacker
	try_unlock()

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
	var skill_points = 1
	var lotuses = 0
	if level >= 10:
		lotuses = round(3 * pow(level, 1.5))
	elif level >= 5:
		lotuses = level * 10
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
	update_border()
	emit_signal("slottable_updated")

func level_up():
	self.level += 1

func try_unlock(monster = null, zone = null):
	if attacker == null or !locked:
		return
	if attacker.level >= unlock_signal_level:
		locked(false)
		if !attacker.ready:
			yield(attacker, "ready")
		attacker.try_equip_skill(self, true)
		attacker.disconnect("level_changed", self, "try_unlock")

func locked(var value):
	locked = value
	emit_signal("slottable_updated")

func lock():
	if unlock_signal_level > 0:
		locked = true

func unlock():
	locked = false
	emit_signal("slottable_updated") # Legacy, should use unlocked signal, but fuck it

func try_equip(var value):
	if attacker != null:
		attacker.try_equip_skill(self, value)

func equipped(var value):
	equipped = value
	emit_signal("slottable_updated")

func update_cooldowns(auto_combat, multi):
	if attacker != null:
		auto_cooldown = base_cooldown * multi
		manual_cooldown = base_cooldown * attacker.stats["manual_cd_multi"] * multi
		if auto_combat:
			cooldown = auto_cooldown
		else:
			cooldown = manual_cooldown

func update_border():
	if level <= 5:
		border_texture = BorderTexture1
	elif level <= 10:
		border_texture = BorderTexture2
	elif level <= 15:
		border_texture = BorderTexture3
	else:
		border_texture = BorderTexture4

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
