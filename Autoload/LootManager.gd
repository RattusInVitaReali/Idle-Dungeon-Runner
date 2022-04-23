extends Node

signal item_acquired

func get_item(item):
	emit_signal("item_acquired", item)

# Generates 1 item, 1 item part and 1 material
func generate_test_loot():
	var Oak = load("res://Materials/Basic/Oak.tscn")
	
	var Bloodsteel = load("res://Materials/Rare/Bloodsteel.tscn")
	var SwordBlade = load("res://ItemParts/SwordBlade/SwordBlade.tscn")
	
	var Sword = load("res://Items/Sword/Sword.tscn")
	
	var oak = Oak.instance()
	var bloodsteel = Bloodsteel.instance()
	var sword_blade = SwordBlade.instance()
	sword_blade.set_mat(bloodsteel)
	var sword = Sword.instance()
	sword.test()
	
	get_item(oak)
	get_item(sword_blade)
	get_item(sword)
	
