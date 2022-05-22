extends Node2D
class_name Main

enum SCREEN { COMBAT, INVENTORY, PART_FORGE, ITEM_FORGE, STATS }

onready var bottom_bar = $UI/BottomBar

onready var screens = {
	SCREEN.COMBAT: $CombatScreen,
	SCREEN.INVENTORY: $InventoryScreen,
	SCREEN.PART_FORGE: $PartForgeScreen,
	SCREEN.ITEM_FORGE: $ItemForgeScreen,
	SCREEN.STATS: $StatsScreen
}

var curr_screen = 0

func _ready():
	bottom_bar.connect("change_screen", self, "change_screen")

func move_camera(screen):
	$Camera2D.position = screen.position

func change_screen(screen_enum):
	var screen = screens[screen_enum]
	screen.on_focused()
	move_camera(screen)
