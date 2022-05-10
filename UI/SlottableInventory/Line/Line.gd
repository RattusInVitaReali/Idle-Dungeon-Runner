extends VBoxContainer

signal inspector

const Slot = preload("res://UI/Slot/Slot.tscn")
const Margin = preload("res://UI/SlottableInventory/Line/LineMargin.tscn")

onready var slots = []


func init(slot_count = 6):
	var last_margin = null
	for i in range(slot_count):
		var new_slot = Slot.instance()
		var new_margin = Margin.instance()
		last_margin = new_margin
		$Line.add_child(new_slot)
		$Line.add_child(new_margin)
		slots.append(new_slot)
		new_slot.connect("inspector", self, "_on_inspector")
	$Line.remove_child(last_margin)
	last_margin.queue_free()

func update_line(items):
	var i = 0
	for slot in slots:
		if i < items.size():
			slot.set_slottable(items[i])
		else:
			slot.set_slottable(null)
		i += 1

func _on_inspector(slottable, gear):
	emit_signal("inspector", slottable, gear)
