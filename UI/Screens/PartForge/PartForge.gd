extends Screen

onready var materials = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func _ready():
	materials.connect("inspector", self, "_on_inspector")

func add_material(mat):
	materials.add_slottable(mat)

func _on_inspector(inspector):
	add_child(inspector)
