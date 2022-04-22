extends Node2D

var screen_order = ["CombatScreen", "InventoryScreen"]

var curr_screen = 0

func move_camera(screen):
	$Camera2D.position = screen.position

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		curr_screen = (curr_screen + 1) % screen_order.size()
		switch_scene(screen_order[curr_screen])

func switch_scene(scene):
	move_camera(get_node(scene))
