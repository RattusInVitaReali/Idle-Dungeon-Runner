extends Node2D
class_name Main

enum SCREEN { COMBAT, INVENTORY, PART_FORGE, ITEM_FORGE, STATS, ZONES, SKILLS }

onready var bottom_bar = $UI/BottomBar
onready var tween = $UI/Tween
onready var dimm = $UI/DimmControl

onready var screens = {
	SCREEN.COMBAT: $CombatScreen,
	SCREEN.INVENTORY: $InventoryScreen,
	SCREEN.PART_FORGE: $PartForgeScreen,
	SCREEN.ITEM_FORGE: $ItemForgeScreen,
	SCREEN.STATS: $StatsScreen,
	SCREEN.ZONES: $ZoneScreen,
	SCREEN.SKILLS: $SkillsScreen
}

var curr_screen = 0

func _ready():
	bottom_bar.connect("change_screen", self, "change_screen")
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")

func move_camera(screen):
	$Camera2D.position = screen.position

func change_screen(screen_enum):
	var screen = screens[screen_enum]
	screen.on_focused()
	move_camera(screen)

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
