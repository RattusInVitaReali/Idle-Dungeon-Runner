extends Control

onready var label = $Background/Label


func _on_TextureButton_toggled(button_pressed):
	if button_pressed:
		CombatProcessor.enter_auto_combat()
		label.text = "COMBAT MODE:\nAUTO"
	elif not button_pressed:
		CombatProcessor.enter_manual_combat()
		label.text = "COMBAT MODE:\nMANUAL"
