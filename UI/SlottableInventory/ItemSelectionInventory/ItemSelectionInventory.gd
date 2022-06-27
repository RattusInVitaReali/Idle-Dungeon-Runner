extends SlottableInventory
class_name ItemSelectionInventory

signal item_type_selected

onready var items = [CraftingManager.Sword]

func _ready():
	for item in items:
		add_slottable(item.instance())

func _on_inspector(slot, _flags):
	emit_signal("item_type_selected", slot)
