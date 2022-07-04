extends SlottableInventory
class_name ItemPreviewInventory

var item = null

func set_item(_item):
	item = _item
	update_inventory()

func get_items_container():
	if item != null:
		return item.get_children()
	return []
