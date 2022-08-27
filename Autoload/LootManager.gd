extends Node
class_name LootManagerScript

signal item_acquired
signal get_experience

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

func _on_get_experience(experience):
	emit_signal("get_experience", experience)
