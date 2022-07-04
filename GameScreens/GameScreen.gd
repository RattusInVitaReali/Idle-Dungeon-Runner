extends Node2D
class_name GameScreen

signal lost_focus

func on_focused():
	pass

func on_lost_focus():
	emit_signal("lost_focus")
