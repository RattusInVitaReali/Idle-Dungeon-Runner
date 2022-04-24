extends GameScreen

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM_PART:
		$ItemForge.add_part(item)
