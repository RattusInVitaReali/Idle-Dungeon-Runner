extends FullScreenPopup
class_name IdleReward

onready var inventory = $Panel/VBoxContainer/SlottableInventory
onready var time = $Panel/VBoxContainer/Time

func add_lootable(slottable):
	inventory.add_slottable(slottable)

func set_time(_time):
	var hours = _time / 3600
	var mins = _time / 60 % 60
	time.text = ""
	if hours > 0:
		time.text += str(hours) + "h "
	time.text += str(mins) + "m"
