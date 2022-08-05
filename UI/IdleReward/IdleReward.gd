extends Control
class_name IdleReward

onready var inventory = $Panel/VBoxContainer/SlottableInventory
onready var time = $Panel/VBoxContainer/Time

func _on_TextureButton_pressed():
	for slottable in inventory.get_items_container().get_children():
		inventory.get_items_container().remove_child(slottable)
		LootManager.get_item(slottable)
	queue_free()

func add_lootable(slottable):
	inventory.add_slottable(slottable)

func set_time(_time):
	var hours = _time / 3600
	var mins = _time / 60 % 60
	time.text = ""
	if hours > 0:
		time.text += str(hours) + "h "
	time.text += str(mins) + "m"
