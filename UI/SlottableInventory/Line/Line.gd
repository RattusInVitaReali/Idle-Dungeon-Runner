extends VBoxContainer

signal inspector

onready var slots = [$Line/Slot1, $Line/Slot2, $Line/Slot3, $Line/Slot4, $Line/Slot5, $Line/Slot6]

func _ready():
	for slot in slots:
		slot.connect("inspector", self, "_on_inspector")

func update_line(items):
	var i = 0
	for slot in slots:
		if i < items.size():
			slot.set_slottable(items[i])
		else:
			slot.set_slottable(null)
		i += 1

func _on_inspector(inspector):
	emit_signal("inspector", inspector)
