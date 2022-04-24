extends Screen

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func add_item(item):
	items.add_item(item)
