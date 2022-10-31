extends StatsInspector
class_name PartInspector

onready var buttons_line = $Panel/VBoxContainer/ButtonsLine
onready var buttons_container = $Panel/VBoxContainer/Buttons

func set_slot(_slot):
	.set_slot(_slot)
	if slot.hide_inspector_buttons:
		hide_buttons()

func update_special():
	if slottable.special != "":
		special.text = slottable.special
	else:
		special.hide()
		special_line.hide()

func hide_buttons():
	buttons_line.hide()
	buttons_container.hide()

func _on_Button1_pressed():
	LootManager.get_item(slottable.try_to_merge())
	queue_free()

func _on_Button2_pressed():
	get_confirm_response("Are you sure you want to dismantle ALL " + slottable.slottable_name + "s? You will get 25% of the materials required to craft them.")
	if yield(self, "confirm_response"):
		slottable.dismantle()
		queue_free()
