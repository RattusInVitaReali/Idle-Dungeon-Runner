extends Inspector
class_name MaterialInspector

onready var merge_line = $Panel/VBoxContainer/Line5
onready var merge_button = $Panel/VBoxContainer/Buttons

func set_slot(slot):
	.set_slot(slot)
	if slot.hide_quantity:
		merge_line.hide()
		merge_button.hide()

func update_special():
	if slottable.special_weapon and slottable.special_armor:
		special.text = "Weapon: " + slottable.special_weapon + "\nArmor: " + slottable.special_armor
	elif slottable.special_weapon:
		special.text = "Weapon: " + slottable.special_weapon
	elif slottable.special_armor:
		special.text = "Armor: " + slottable.special_armor
	else:
		special.hide()
		special_line.hide()

func _on_Button1_pressed():
	LootManager.get_item(slottable.try_to_merge())
	queue_free()

func _on_TextureButton_pressed():
	queue_free()
