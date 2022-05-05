extends Screen

onready var parts = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func _ready():
	parts.connect("inspector", self, "_on_inspector")

func add_part(part):
	parts.add_slottable(part)
