extends Screen

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func update_items():
	items.update_inventory()

func add_item(item):
	items.add_item(item)
