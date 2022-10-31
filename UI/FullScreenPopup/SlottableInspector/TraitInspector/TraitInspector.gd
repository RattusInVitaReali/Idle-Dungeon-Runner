extends SlottableInspector
class_name TraitInspector

signal try_allocate

onready var active = $Panel/VBoxContainer/Active
onready var active_line = $Panel/VBoxContainer/ActiveLine
onready var description = $Panel/VBoxContainer/Description
onready var allocate = $Panel/VBoxContainer/Buttons/Allocate/Label

var spec

func set_slot(_slot):
	spec = _slot.spec
	.set_slot(_slot)

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_active()
	update_description()
	update_allocate()
	slottable.connect("slottable_updated", self, "_on_slottable_updated")

func _on_slottable_updated():
	update_all()

func update_all():
	update_active()
	update_icon()
	update_description()
	update_allocate()

func update_active():
	if slottable.active:
		active.show()
		active_line.show()
	else:
		active.hide()
		active_line.hide()

func update_description():
	description.text = slottable.description()

func update_allocate():
	#print("spec level: ", spec.level, " level req: ", slottable.level_required)
	if slottable.active:
		allocate.text = "Allocated"
		allocate.self_modulate = Color(1, 1, 1, 0.5)
	elif spec.level != slottable.level_required:
		allocate.text = "Locked"
		allocate.self_modulate = Color(1, 1, 1, 0.5)
	elif GlobalResources.get_gr_quantity(GlobalResources.GR.TRAIT_POINT) == 0:
		allocate.text = "Allocate"
		allocate.self_modulate = Color(1, 1, 1, 0.5)
	else:
		allocate.text = "Allocate"
		allocate.self_modulate = Color(1, 1, 1, 1)

func _on_Allocate_pressed():
	if !slottable.active:
		emit_signal("try_allocate", spec, slottable)
