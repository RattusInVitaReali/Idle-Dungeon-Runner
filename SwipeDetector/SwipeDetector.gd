extends Node2D
class_name SwipeDetector

signal swiped

export (float) var max_diagonal_slope = 1.3
export (int) var min_distance = 200

var start_pos

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		start_detection(event.position)
	elif not $Timer.is_stopped():
		end_detection(event.position)

func start_detection(pos):
	start_pos = pos
	$Timer.start()

func end_detection(pos):
	$Timer.stop()
	if pos.distance_to(start_pos) < min_distance:
		return
	var dir = (pos - start_pos).normalized()
	if abs(dir.x) + abs(dir.y) >= max_diagonal_slope:
		return
	if abs(dir.x) > abs(dir.y):
		emit_signal("swiped", Vector2(-sign(dir.x), 0))
	else:
		emit_signal("swiped", Vector2(0, -sign(dir.y)))
