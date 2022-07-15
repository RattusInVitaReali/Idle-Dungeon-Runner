extends Slot
class_name SkillSlot

# Probably move this stuff to Skill
const LockedBorder = preload("res://_Resources/skill_borders/Border3.png")
const Lock = preload("res://_Resources/skill_icons/lock.png")

onready var skill_name = $NameBackground/Name

func set_slottable(_slottable):
	slottable = _slottable
	if slottable != null:
		slottable.connect("slottable_updated", self, "update_skill")
	update_skill()

func set_icon():
	$SlottableIcon.set_slottable(slottable)
	if slottable == null:
		skill_name.text = ""
	elif !slottable.locked:
		skill_name.text = slottable.skill_name
	else:
		skill_name.text = "Locked"

func set_equipped():
	if slottable != null:
		$Equipped.visible = slottable.equipped
	else:
		$Equipped.hide()

func update_skill():
	set_icon()
	set_equipped()

func _on_Button_pressed():
	if slottable != null:
		if !slottable.locked:
			inspector()
