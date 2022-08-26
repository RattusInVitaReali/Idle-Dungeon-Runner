extends SlottableInventory
class_name PartSelectionInventory

signal part_type_selected
	
func _ready():
	for part_type in CraftingManager.part_scenes:
		var part = CraftingManager.part_scenes[part_type].instance()
		if !Progression.item_part_unlocked[part_type]:
			part.lock()
			part.connect("unlocked", self, "_on_part_unlocked")
		add_slottable(part, false)
	update_inventory()

func _on_part_unlocked(part):
	update_inventory()

func get_sorted_order():
	var items = get_items_container().get_children()
	sort(items, "_sort_part_type")
	sort(items, "_sort_locked")
	return items

func _on_inspector(slot):
	emit_signal("part_type_selected", slot)

