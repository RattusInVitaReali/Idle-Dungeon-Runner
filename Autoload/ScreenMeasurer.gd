extends Node
class_name ScreenMeasurerScript

var width = 0
var height = 0
var aspect_ratio = 9 / 16

var screen_scale = 1

func _ready():
	width = get_viewport().size.x
	height = get_viewport().size.y
	aspect_ratio = width / height
	screen_scale = width / 1080

func get_screen_size():
	return Vector2(1080, height / screen_scale)

func get_game_scale():
	return Vector2(screen_scale, screen_scale)
