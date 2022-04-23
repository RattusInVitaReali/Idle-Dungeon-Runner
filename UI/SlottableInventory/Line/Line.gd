extends VBoxContainer

onready var slots = [$Line/Slot1, $Line/Slot2, $Line/Slot3, $Line/Slot4, $Line/Slot5, $Line/Slot6]

func update_line(items):
	var i = 0
	for slot in slots:
		if i < items.size():
			slot.update_slot(items[i])
		else:
			slot.update_slot(null)
		i += 1
