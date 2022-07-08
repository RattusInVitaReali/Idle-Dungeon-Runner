extends SlottableInventory
class_name ItemSelectionInventory

signal item_type_selected

func _ready():
	return
	for item in CraftingManager.item_scenes:
		var scene = load(CraftingManager.item_scenes[item])
		add_slottable(scene.instance())

func _on_inspector(slot, _flags):
	emit_signal("item_type_selected", slot)

func add_slottable(slottable : Slottable):
	get_items_container().add_child(slottable)
	slottable.connect("tree_exited", self, "update_inventory")
	update_inventory()
