extends TextureRect

const type_icons = {
	Skill.UPGRADE_REQS.LOTUS : preload("res://_Resources/lotus.png"),
	Skill.UPGRADE_REQS.SKILL_POINT : preload("res://_Resources/SkillIcon.png")
}

const type_signals = {
	Skill.UPGRADE_REQS.LOTUS : "skill_lotuses_changed",
	Skill.UPGRADE_REQS.SKILL_POINT : "skill_points_changed"
}

var type
var amount = 0
var required = 0

onready var icon = $HBoxContainer/Icon
onready var amount_label = $HBoxContainer/Amount

func set_requirement(_type, _required):
	type = _type
	required = _required
	GlobalResources.connect(type_signals[type], self, "update_amount")
	icon.texture = type_icons[type]
	update_text()

func update_text():
	amount = GlobalResources.get(Skill.req_type_vars[type])
	amount_label.text = str(amount) + " / " + str(required)
	if amount >= required:
		amount_label.add_color_override("font_color", Color(0, 0.8, 0.3, 1))
	else:
		amount_label.add_color_override("font_color", Color(1, 0, 0, 1))
