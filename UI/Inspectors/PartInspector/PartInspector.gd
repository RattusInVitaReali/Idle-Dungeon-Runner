extends Inspector
class_name PartInspector

signal merge

func _on_Button1_pressed():
	emit_signal("merge", slottable)
	queue_free()

func _on_Cancel_pressed():
	queue_free()

func _on_TextureButton_pressed():
	_on_Cancel_pressed()
