extends Node

signal item_acquired

func get_item(item):
	if item != null:
		emit_signal("item_acquired", item)

func _on_loot(loot):
	for lootable in loot:
		get_item(lootable.roll_loot())
