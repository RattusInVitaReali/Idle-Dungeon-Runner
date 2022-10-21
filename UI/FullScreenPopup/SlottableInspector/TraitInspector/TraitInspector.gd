extends SlottableInspector
class_name TraitInspector

signal try_allocate

onready var active = $Panel/VBoxContainer/Active
onready var active_line = $Panel/VBoxContainer/ActiveLine
onready var description = $Panel/VBoxContainer/Description

var spec

func set_slot(_slot):
	.set_slot(_slot)
	spec = slot.spec

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_active()
	update_description()
	slottable.connect("slottable_updated", self, "_on_slottable_updated")

func _on_slottable_updated():
	update_active()
	update_icon()

func update_active():
	if slottable.active:
		active.show()
		active_line.show()
	else:
		active.hide()
		active_line.hide()

func update_description():
	description.text = slottable.description()

func _on_Allocate_pressed():
	if !slottable.active:
		emit_signal("try_allocate", spec, slottable)
