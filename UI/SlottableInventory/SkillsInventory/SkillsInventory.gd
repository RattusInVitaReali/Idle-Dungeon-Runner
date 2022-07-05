extends SlottableInventory
class_name SkillsInventory

const SkillSlot = preload("res://UI/Slot/SkillSlot/SkillSlot.tscn")

var skills = null

func update_inventory(var reorder = true):
	.update_inventory(false)

func set_items_container(var container):
	skills = container
	update_inventory()

func get_items_container():
	if skills != null:
		return skills
	return $Items
