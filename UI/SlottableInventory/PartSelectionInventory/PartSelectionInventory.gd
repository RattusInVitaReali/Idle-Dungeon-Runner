extends SlottableInventory
class_name PartSelectionInventory

signal part_type_selected

func _ready():
	return
	for part in CraftingManager.part_scenes:
		add_slottable(CraftingManager.part_scenes[part].instance())

func _on_inspector(slot, flags):
	emit_signal("part_type_selected", slot)
