extends ItemInspector
class_name ItemConfirmInspector

signal confirmed

# HACKERINO
func _on_Equip_pressed():
	emit_signal("confirmed", true)
	queue_free()

func _on_Cancel_pressed():
	emit_signal("confirmed", false)
	queue_free()

func _on_TextureButton_pressed():
	_on_Cancel_pressed()
