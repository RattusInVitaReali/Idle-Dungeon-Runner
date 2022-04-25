extends Screen

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func _ready():
	items.connect("inspector", self, "_on_inspector")

func add_item(item):
	items.add_item(item)

func _on_inspector(inspector):
	add_child(inspector)
