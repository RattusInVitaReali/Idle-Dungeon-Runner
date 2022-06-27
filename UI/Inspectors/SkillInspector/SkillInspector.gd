extends Inspector
class_name SkillInspector

const BorderTexture1 = preload("res://_Resources/skill_borders/Border3.png")
const BorderTexture2 = preload("res://_Resources/skill_borders/Border4.png")
const BorderTexture3 = preload("res://_Resources/skill_borders/Border5.png")
const BorderTexture4 = preload("res://_Resources/skill_borders/Border6.png")

const UpgradeRequirement = preload("res://UI/Inspectors/SkillInspector/UpgradeRequirement/UpgradeRequirement.tscn")

onready var actual_icon = $Panel/VBoxContainer/Image/Icon/ActualIcon
onready var skill_tags = $Panel/VBoxContainer/SkillTags
onready var skill_level = $Panel/VBoxContainer/SkillLevel
onready var skill_description = $Panel/VBoxContainer/Stats/StatsContainer/SkillDescription
onready var upgrade_req_container = $Panel/VBoxContainer/HBoxContainer/UpgradeReqContainter


func set_slottable(_slottable):
	.set_slottable(_slottable)
	slottable.connect("skill_updated", self, "update_skill")
	update_tags()
	update_description()
	update_skill()

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
	update_upgrade_reqs()

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

func update_upgrade_reqs():
	for req in upgrade_req_container.get_children():
		upgrade_req_container.remove_child(req)
		req.queue_free()
	var reqs = slottable.get_upgrade_reqs()
	for req in reqs:
		if reqs[req] != 0:
			var new_req = UpgradeRequirement.instance()
			upgrade_req_container.add_child(new_req)
			new_req.set_requirement(req, reqs[req])

func _on_Upgrade_pressed():
	slottable.try_to_upgrade()

func _on_Equip_pressed():
	pass # Replace with function body.

func update_stats():
	pass

func update_special():
	pass
