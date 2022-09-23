extends TextureRect
class_name SkillIcon

const lock = preload("res://RESOURCES/SkillIcons/Lock.png")

var skill
var cooldown
var max_cooldown

var locked = true

func _ready():
	CombatProcessor.connect("entered_combat", self, "set_enabled")
	CombatProcessor.connect("exited_combat", self, "set_disabled")

func _process(delta):
	if skill != null:
		if skill.equipped and !skill.locked:
			if skill.get_cooldown_timer().get_time_left() >= skill.attacker.get_action_timer().get_time_left():
				cooldown = skill.get_cooldown_timer().get_time_left()
				max_cooldown = skill.cooldown
			else:
				cooldown = skill.attacker.get_action_timer().get_time_left()
				max_cooldown = skill.attacker.stats.action_time
			$CooldownValue.text = "%3.1f" % cooldown
			$CooldownTexture.value = (cooldown / max_cooldown) * 100
			if cooldown > 0:
				$CooldownValue.visible = true
				set_disabled()
			else:
				$CooldownValue.visible = false
			set_enabled()

func set_skill(_skill = null):
	if skill == _skill:
		return
	if skill != null:
		skill.disconnect("tree_exited", self, "update_skill")
		skill.disconnect("slottable_updated", self, "update_skill")
	skill = _skill
	if skill != null:
		skill.connect("tree_exited", self, "update_skill")
		skill.connect("slottable_updated", self, "update_skill")
	else:
		$CooldownValue.visible = false
		$CooldownTexture.value = 0
	update_skill()

func update_skill():
	if locked:
		$SkillIcon.texture_normal = lock
		set_disabled()
		return
	elif skill == null:
		$SkillIcon.texture_normal = null
		set_disabled()
	else:
		$SkillIcon.texture_normal = skill.icon
		set_enabled()

func player_use_skill():
	if skill != null:
		if skill.try_to_use_skill():
			set_disabled()

func set_enabled():
	$SkillIcon.disabled = false

func set_disabled():
	$SkillIcon.disabled = true

func _on_SkillIcon_pressed():
	if not CombatProcessor.auto_combat and CombatProcessor.in_combat:
		skill.attacker.try_to_use_skill(skill)
