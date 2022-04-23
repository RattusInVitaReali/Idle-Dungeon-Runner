extends Screen

onready var materials = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func update_materials():
	materials.update_inventory()

func add_material(mat):
	materials.add_item(mat)
