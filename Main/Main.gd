extends Node2D
class_name Main

enum SCREEN { COMBAT, INVENTORY, PART_FORGE, ITEM_FORGE, STATS, ZONES, SKILLS, SPECIALIZATIONS }

onready var bottom_bar = $BottomBarUI/BottomBar
onready var tween = $BottomBarUI/Tween
onready var dimm = $BottomBarUI/DimmControl

onready var screens = {
	SCREEN.COMBAT: $Combat,
	SCREEN.INVENTORY: $Inventory,
	SCREEN.PART_FORGE: $PartForge,
	SCREEN.ITEM_FORGE: $ItemForge,
	SCREEN.STATS: $Stats,
	SCREEN.ZONES: $Zones,
	SCREEN.SKILLS: $Skills,
	SCREEN.SPECIALIZATIONS: $Specializations
}

onready var screen = screens[SCREEN.COMBAT]
var curr_screen = SCREEN.COMBAT

func _ready():
	scale = ScreenMeasurer.get_game_scale()
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")
	Saver.connect("idle_reward", self, "_on_idle_reward")

func move_camera():
	$Camera2D.position = screen.rect_position

func change_screen(screen_enum):
	screen.on_lost_focus()
	screen = screens[screen_enum]
	curr_screen = screen_enum
	screen.on_focused()
	move_camera()

func _on_SwipeDetector_swiped(dir):
	if dir.x == 1:
		change_screen(min(curr_screen + 1, screens.size() - 1))
	elif dir.x == -1:
		change_screen(max(curr_screen - 1, 0))

func _on_zone_changed(_zone):
	tween.interpolate_property(
		dimm, 
		"self_modulate", 
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		0.3, 
		Tween.TRANS_CUBIC, 
		Tween.EASE_IN
	)
	tween.start()
	yield(tween, "tween_completed")
	change_screen(SCREEN.COMBAT)
	tween.interpolate_property(
		dimm, 
		"self_modulate", 
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 0), 
		0.3, 
		Tween.TRANS_CUBIC, 
		Tween.EASE_IN
	)

func start_upgrade_process(var item):
	change_screen(SCREEN.ITEM_FORGE)
	$ItemForge.start_upgrade(item)

func end_upgrade_process():
	change_screen(SCREEN.INVENTORY)

func _on_idle_reward(idle_reward):
	add_child(idle_reward)
