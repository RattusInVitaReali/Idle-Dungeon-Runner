extends SlottableInventory
class_name ItemPreviewInventory

var item = null

func set_item(_item):
	item = _item
	update_inventory()

func update_inventory(var reorder = true):
	for line in lines_container.get_children():
		lines_container.remove_child(line)
		line.queue_free()
	if item != null:
		.update_inventory(reorder)

func get_items_container():
	return item
