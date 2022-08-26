extends SlottableInventory
class_name PartSelectionInventory

signal part_type_selected

func _ready():
	for part_type in CraftingManager.part_scenes:
		var part = CraftingManager.part_scenes[part_type].instance()
		if !Progression.item_part_unlocked[part_type]:
			part.lock()
		add_slottable(part, false)
	update_inventory()

func _on_inspector(slot):
	emit_signal("part_type_selected", slot)
