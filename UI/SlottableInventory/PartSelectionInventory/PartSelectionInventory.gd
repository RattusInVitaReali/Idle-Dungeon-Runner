extends SlottableInventory
class_name PartSelectionInventory

signal part_type_selected

onready var parts = [CraftingManager.Pommel, CraftingManager.SwordHandle, CraftingManager.SwordBlade]

func _ready():
	for part in parts:
		add_slottable(part.instance())

func _on_inspector(slottable, gear):
	emit_signal("part_type_selected", slottable)
