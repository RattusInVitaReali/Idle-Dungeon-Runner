extends GameScreen
class_name PartForgeScreen

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
		$PartForge.add_material(item)
