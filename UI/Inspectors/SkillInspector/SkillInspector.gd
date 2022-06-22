extends Inspector

const BorderTexture1 = preload("res://_Resources/skill_borders/Border3.png")
const BorderTexture2 = preload("res://_Resources/skill_borders/Border4.png")
const BorderTexture3 = preload("res://_Resources/skill_borders/Border5.png")
const BorderTexture4 = preload("res://_Resources/skill_borders/Border6.png")

onready var actual_icon = $Panel/VBoxContainer/Image/Icon/ActualIcon
onready var skill_tags = $Panel/VBoxContainer/SkillTags
onready var skill_level = $Panel/VBoxContainer/SkillLevel
onready var skill_description = $Panel/VBoxContainer/Stats/StatsContainer/SkillDescription

func set_slottable(_slottable):
	.set_slottable(_slottable)
	slottable.connect("skill_updated", self, "update_skill")
	update_tags()
	update_level()
	update_description()

func get_border_texture():
	if slottable.level <= 5:
		return BorderTexture1
	elif slottable.level <= 10:
		return BorderTexture2
	elif slottable.level <= 15:
		return BorderTexture3
	else:
		return BorderTexture4

func update_skill():
	update_level()
	update_description()
	update_icon()

func update_icon():
	icon.texture = get_border_texture()
	actual_icon.texture = slottable.icon

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

func _on_Upgrade_pressed():
	slottable.levelup()

func _on_Equip_pressed():
	pass # Replace with function body.

func update_stats():
	pass

func update_special():
	pass
