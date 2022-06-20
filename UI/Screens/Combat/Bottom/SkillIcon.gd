extends TextureRect

const lock = preload("res://_Resources/skill_icons/lock.png")

var skill
var cooldown
var max_cooldown

func _ready():
	CombatProcessor.connect("entered_combat", self, "set_enabled")
	CombatProcessor.connect("exited_combat", self, "set_disabled")
	update_skill(null)

func _process(delta):
	if skill != null:
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

func update_skill(_skill = null):
	if skill == _skill:
		return
	skill = _skill
	if skill != null:
		$SkillIcon.texture_normal = skill.icon
		$SkillIcon.disabled = false
		skill.connect("tree_exited", self, "update_skill")
	else:
		$SkillIcon.texture_normal = lock
		$SkillIcon.disabled = true

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
