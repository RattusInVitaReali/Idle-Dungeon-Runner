extends Inspector

signal merge

func update_special():
	if slottable.special_weapon and slottable.special_armor:
		special.text = "Weapon: " + slottable.special_weapon + "\nArmor: " + slottable.special_armor
	elif slottable.special_weapon:
		special.text = "Weapon: " + slottable.special_weapon
	elif slottable.special_armor:
		special.text = "Armor: " + slottable.special_armor
	else:
		special.text = ""

func _on_Button1_pressed():
	emit_signal("merge", slottable)
	queue_free()

func _on_Cancel_pressed():
	queue_free()

func _on_TextureButton_pressed():
	_on_Cancel_pressed()
