extends Control
class_name FullScreenPopup

const ConfirmDialog = preload("res://UI/ConfirmDialog/ConfirmDialog.tscn")

signal confirm_response

func _on_TextureButton_pressed():
	queue_free()

func get_confirm_response(question):
	var confirm_dialog = ConfirmDialog.instance()
	add_child(confirm_dialog)
	confirm_dialog.set_question(question)
	emit_signal("confirm_response", yield(confirm_dialog, "response"))
