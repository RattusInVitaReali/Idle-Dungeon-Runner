extends SlottableInventory
class_name ItemSelectionInventory

signal item_type_selected

func _ready():
	for item_type in CraftingManager.item_scenes:
		var item = CraftingManager.item_scenes[item_type].instance()
		if !Progression.item_unlocked[item_type]:
			item.lock()
			item.connect("unlocked", self, "_on_item_unlocked")
		add_slottable(item, false)
	update_inventory()

func _on_item_unlocked(item):
	update_inventory()

func get_sorted_order():
	var items = get_items_container().get_children()
	sort(items, "_sort_item_type")
	sort(items, "_sort_locked")
	return items

func _on_inspector(slot):
	emit_signal("item_type_selected", slot)
