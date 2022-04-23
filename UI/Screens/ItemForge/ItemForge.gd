extends Screen

onready var parts = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func update_parts():
	parts.update_inventory()

func add_part(part):
	parts.add_item(part)
