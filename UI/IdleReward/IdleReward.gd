extends Control
class_name IdleReward

onready var inventory = $Panel/VBoxContainer/SlottableInventory

func _on_TextureButton_pressed():
	for slottable in inventory.get_items_container().get_children():
		inventory.get_items_container().remove_child(slottable)
		LootManager.get_item(slottable)
	queue_free()

func add_lootable(slottable):
	inventory.add_slottable(slottable)
