extends PartInspector

signal confirmed

func _on_Confirm_pressed():
	emit_signal("confirmed", true)
	queue_free()

func _on_Cancel_pressed():
	emit_signal("confirmed", false)
	queue_free()

func _on_TextureButton_pressed():
	_on_Cancel_pressed()
