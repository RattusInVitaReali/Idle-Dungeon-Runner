extends ItemInspector
class_name ItemConfirmInspector

signal confirmed

func _on_Button1_pressed():
	emit_signal("confirmed", true)
	queue_free()

func _on_Button2_pressed():
	emit_signal("confirmed", false)
	queue_free()

func _on_TextureButton_pressed():
	_on_Button2_pressed()
