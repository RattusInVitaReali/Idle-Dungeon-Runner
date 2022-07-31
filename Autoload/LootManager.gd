extends Node

signal item_acquired

func get_item(item):
	if item != null:
		emit_signal("item_acquired", item)

func _on_loot(loot):
	for item in roll_loot(loot):
		get_item(item)

func roll_loot(_loot):
	var loot = []
	for lootable in _loot:
		loot.append(lootable.roll_loot())
	return loot
