extends Inspector
class_name PartInspector

onready var buttons_line = $Panel/VBoxContainer/Line5
onready var buttons_container = $Panel/VBoxContainer/Buttons

func set_slot(_slot):
	.set_slot(_slot)
	if slot.hide_inspector_buttons:
		hide_buttons()

func hide_buttons():
	buttons_line.hide()
	buttons_container.hide()

func _on_Button1_pressed():
	LootManager.get_item(slottable.try_to_merge())
	queue_free()

func _on_TextureButton_pressed():
	queue_free()

func _on_Button2_pressed():
	slottable.dismantle()
	queue_free()
