extends Inspector
class_name MaterialInspector

func set_slot(slot):
	.set_slot(slot)

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

func _on_TextureButton_pressed():
	queue_free()
