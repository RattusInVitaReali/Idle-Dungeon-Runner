extends Slot
class_name SkillSlot

const LockedBorder = preload("res://RESOURCES/SkillBorders/Border3.png")
const Lock = preload("res://RESOURCES/SkillIcons/Lock.png")

onready var skill_name = $Background/NameBackground/Name
onready var equipped = $Background/Equipped

func set_slottable(_slottable):
	slottable = _slottable
	if slottable != null:
		slottable.connect("slottable_updated", self, "update_skill")
	update_skill()

func set_icon():
	icon.set_slottable(slottable)
	if slottable == null:
		skill_name.text = ""
	elif !slottable.locked:
		skill_name.text = slottable.skill_name
	else:
		skill_name.text = "Locked"

func set_equipped():
	if slottable != null:
		equipped.visible = slottable.equipped
	else:
		equipped.hide()

func update_skill():
	set_icon()
	set_equipped()

func _on_Button_pressed():
	if slottable != null:
		if !slottable.locked:
			inspector()
