extends Inspector
class_name SkillInspector

const UpgradeRequirement = preload("res://UI/Inspectors/SkillInspector/UpgradeRequirement/UpgradeRequirement.tscn")

onready var skill_tags = $Panel/VBoxContainer/SkillTags
onready var skill_level = $Panel/VBoxContainer/SkillLevel
onready var skill_description = $Panel/VBoxContainer/Stats/StatsContainer/SkillDescription
onready var equip_button = $Panel/VBoxContainer/Buttons/Equip/Label
onready var upgrade_req_container = $Panel/VBoxContainer/HBoxContainer/UpgradeReqContainter


func set_slottable(_slottable):
	.set_slottable(_slottable)
	slottable.connect("slottable_updated", self, "update_skill")
	update_tags()
	update_description()
	update_skill()

func update_skill():
	update_level()
	update_description()
	update_icon()
	update_upgrade_reqs()
	update_button()

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

func update_button():
	if slottable.equipped:
		equip_button.text = "Unequip"
	else:
		equip_button.text = "Equip"

func _on_Upgrade_pressed():
	slottable.try_to_upgrade()

func _on_Equip_pressed():
	slottable.equip(!slottable.equipped)
	._on_TextureButton_pressed()

func update_stats():
	pass

func update_special():
	pass
