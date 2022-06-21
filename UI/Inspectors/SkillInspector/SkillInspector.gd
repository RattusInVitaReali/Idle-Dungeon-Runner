extends Inspector

const BorderTexture = preload("res://_Resources/skill_borders/Border3.png")

onready var actual_icon = $Panel/VBoxContainer/Image/Icon/ActualIcon
onready var skill_tags = $Panel/VBoxContainer/SkillTags
onready var skill_level = $Panel/VBoxContainer/SkillLevel
onready var skill_description = $Panel/VBoxContainer/Stats/StatsContainer/SkillDescription

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_tags()
	update_level()
	update_description()

func update_icon():
	icon.texture = BorderTexture
	actual_icon.texture = slottable.icon

func update_stats():
	var label = StatLabel.instance()

func update_special():
	pass

func update_tags():
	var text = ""
	for tag in slottable.tags:
		text += Skill.SKILL_TAGS.keys()[tag].capitalize() + " - "
	text.erase(text.length() - 3, 3)
	skill_tags.text = text

func update_level():
	skill_level.text = "Level " + str(slottable.level)

func update_description():
	skill_description.text = slottable.description()
