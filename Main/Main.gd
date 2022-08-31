extends Node2D
class_name Main

enum SCREEN { COMBAT, INVENTORY, PART_FORGE, ITEM_FORGE, STATS, ZONES, SKILLS }

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
	SCREEN.SKILLS: $Skills
}

onready var screen = screens[SCREEN.COMBAT]

var curr_screen = SCREEN.COMBAT
var height
var width

func _ready():
	bottom_bar.connect("change_screen", self, "change_screen")
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")
	screens[SCREEN.INVENTORY].connect("upgrade", self, "start_upgrade_process")
	screens[SCREEN.ITEM_FORGE].connect("upgrade_finished", self, "end_upgrade_process")

func measure_screen():
	height = get_viewport().size.y
	width = get_viewport().size.x

func move_camera():
	$Camera2D.position = screen.rect_position

func change_screen(screen_enum):
	screen.on_lost_focus()
	screen = screens[screen_enum]
	screen.on_focused()
	move_camera()

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
