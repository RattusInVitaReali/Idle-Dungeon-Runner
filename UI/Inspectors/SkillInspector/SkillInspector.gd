extends Inspector

const BorderTexture = preload("res://_Resources/skill_borders/Border3.png")

onready var actual_icon = $Panel/VBoxContainer/Image/Icon/ActualIcon

func update_icon():
	icon.texture = BorderTexture
	actual_icon.texture = slottable.icon

func update_stats():
	pass

func update_special():
	pass
