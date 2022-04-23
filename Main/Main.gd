extends Node2D

onready var screen_order = [$CombatScreen, $InventoryScreen, $PartForgeScreen, $ItemForgeScreen]

var curr_screen = 0

func _ready():
	pass

func move_camera(screen):
	$Camera2D.position = screen.position

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		next_screen()

func next_screen():
	curr_screen = (curr_screen + 1) % screen_order.size()
	switch_screen(screen_order[curr_screen])

func switch_screen(screen):
	screen.on_focused()
	move_camera(screen)
