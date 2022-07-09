extends SlottableInventory
class_name ItemSelectionInventory

signal item_type_selected

func _ready():
	for item in CraftingManager.item_scenes:
		add_slottable(CraftingManager.item_scenes[item].instance(), false)
	update_inventory()

func _on_inspector(slot, _flags):
	emit_signal("item_type_selected", slot)
