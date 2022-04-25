extends Screen

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory

func _ready():
	items.connect("inspector", self, "_on_inspector")

func add_item(item):
	items.add_item(item)

func _on_inspector(inspector):
	add_child(inspector)
	inspector.connect("equip", self, "_on_equip")

func _on_equip(item):
	items.remove_item(item)
	CombatProcessor.Player.equip_item(item)
