extends Node

signal item_acquired

func get_item(item):
	emit_signal("item_acquired", item)

func _on_loot(loot):
	for lootable in loot:
		var new = lootable.get_loot()
		get_item(new)

# Generates 1 item, 1 item part and 1 material
func generate_test_loot():
	
	var oak = CraftingManager.CraftingMaterial.instance()
	var sword_blade = CraftingManager.TestSwordBlade.instance()
	var sword = CraftingManager.TestSword.instance()
	
	oak.set_mat(CraftingManager.Oak)
	oak.quantity = randi() % 5 + 1
	sword_blade.test()
	sword.test()
	
	get_item(oak)
	get_item(sword_blade)
	get_item(sword)
