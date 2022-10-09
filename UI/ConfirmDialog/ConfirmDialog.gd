extends Control
class_name ConfirmDialog

signal response

onready var question = $Panel/VBoxContainer/Question

func set_question(_question):
	question.text = _question

func _on_TextureButton_pressed():
	_on_Cancel_pressed()

func _on_Confirm_pressed():
	emit_signal("response", true)
	queue_free()

func _on_Cancel_pressed():
	emit_signal("response", false)
	queue_free()
