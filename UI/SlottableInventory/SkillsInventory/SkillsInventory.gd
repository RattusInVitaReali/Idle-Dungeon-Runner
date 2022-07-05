extends SlottableInventory
class_name SkillsInventory

const SkillSlot = preload("res://UI/Slot/SkillSlot/SkillSlot.tscn")

var skills = []

func add_slottable(_slottable):
	if _slottable.slottable_type != Slottable.SLOTTABLE_TYPE.SKILL:
		return
	skills.append(_slottable)
	update_inventory(false)
