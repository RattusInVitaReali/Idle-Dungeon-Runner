extends PartInspector
class_name PartConfirmInspector

signal confirmed

onready var confirm_label = $Panel/VBoxContainer/Buttons/Button1/Label
onready var refinement_label = $Panel/VBoxContainer/Refinement/Label

var mat : CraftingMaterial = null
var refinement_level = 0
var current_cost = 0

func set_slottable(_slottable):
	.set_slottable(_slottable)
	if current_cost == 0:
		current_cost = _slottable.cost
	update_confirm_text()
	update_refinement_text()

func update_confirm_text():
	confirm_label.text = "Confirm (" + str(current_cost) + ")"

func update_refinement_text():
	if refinement_level != 0:
		refinement_label.text = "Refined x" + str(refinement_level)
	else:
		refinement_label.text = "Unrefined"

func set_mat(_mat):
	mat = _mat

func _on_Button1_pressed():
	emit_signal("confirmed", true, refinement_level, current_cost)
	queue_free()

func _on_Button2_pressed():
	emit_signal("confirmed", false, refinement_level, current_cost)
	queue_free()

func _on_TextureButton_pressed():
	_on_Button2_pressed()

func _on_RefineDown_pressed():
	if refinement_level > 0:
		current_cost /= 5
		refinement_level -= 1
		slottable.tier_down()
		set_slottable(slottable)

func _on_RefineUp_pressed():
	if mat.quantity >= 5 * current_cost:
		current_cost *= 5
		refinement_level += 1
		slottable.tier_up()
		set_slottable(slottable)
