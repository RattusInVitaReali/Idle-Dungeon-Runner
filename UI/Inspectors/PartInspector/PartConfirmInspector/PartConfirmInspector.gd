extends PartInspector
class_name PartConfirmInspector

signal confirmed

func _on_Button1_pressed():
	emit_signal("confirmed", true)
	queue_free()

func _on_Cancel_pressed():
	emit_signal("confirmed", false)
	queue_free()
