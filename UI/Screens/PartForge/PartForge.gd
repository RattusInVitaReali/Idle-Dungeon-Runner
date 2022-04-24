extends Screen

onready var materials = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func add_material(mat):
	materials.add_item(mat)
