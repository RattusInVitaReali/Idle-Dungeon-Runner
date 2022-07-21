extends VBoxContainer
class_name Line

signal inspector

const Margin = preload("res://UI/SlottableInventory/Line/LineMargin.tscn")
const Slot = preload("res://UI/Slot/Slot.tscn")

func init(slottables : Array, slot_count = 6, slot_scene : PackedScene = Slot):
	var i = 0
	$Line.add_child(Margin.instance())
	while i < slot_count:
		var slot = slot_scene.instance()
		var margin = Margin.instance()
		$Line.add_child(slot)
		$Line.add_child(margin)
		if i < slottables.size():
			slot.set_slottable(slottables[i])
		else:
			slot.set_slottable(null)
		i += 1
		slot.connect("inspector", self, "_on_inspector")

func _on_inspector(slot):
	emit_signal("inspector", slot)
