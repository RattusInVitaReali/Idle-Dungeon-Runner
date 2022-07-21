extends SlottableInventory
class_name PartSelectionInventory

signal part_type_selected

func _ready():
	for part in CraftingManager.part_scenes:
		add_slottable(CraftingManager.part_scenes[part].instance(), false)
	update_inventory()

func _on_inspector(slot):
	emit_signal("part_type_selected", slot)
