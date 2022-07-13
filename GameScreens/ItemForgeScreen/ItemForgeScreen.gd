extends GameScreen
class_name ItemForgeScreen

signal upgrade_finished

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")
	$ItemForge.connect("upgrade_finished", self, "_on_upgrade_finished")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM_PART:
		$ItemForge.add_part(item)

func start_upgrade_process(var item):
	$ItemForge.start_upgrade(item)

func _on_upgrade_finished():
	emit_signal("upgrade_finished")
