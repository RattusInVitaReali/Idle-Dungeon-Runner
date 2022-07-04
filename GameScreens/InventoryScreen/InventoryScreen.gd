extends GameScreen
class_name InventoryScreen

signal upgrade

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")
	$Inventory.connect("upgrade", self, "_on_upgrade")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM:
		$Inventory.add_item(item)

func _on_upgrade(var item):
	emit_signal("upgrade", item)
