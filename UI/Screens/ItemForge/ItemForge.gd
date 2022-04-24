extends Screen

onready var parts = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func add_part(part):
	parts.add_item(part)
