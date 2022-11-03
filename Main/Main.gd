extends Node2D
class_name Main

const save_path = "user://idle_data.tres"
const IdleReward = preload("res://UI/FullScreenPopup/IdleReward/IdleReward.tscn")

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
	Saver.save_on_exit(self)
	scale = ScreenMeasurer.get_game_scale()
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")
	get_idle_rewards()

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
	tween.start()
	tween.interpolate_property(
		dimm, 
		"self_modulate", 
		Color(1, 1, 1, 0), 
		Color(1, 1, 1, 1), 
		0.3, 
		Tween.TRANS_CUBIC, 
		Tween.EASE_IN
	)
	tween.interpolate_property(
		$BackgroundMusic,
		"volume_db",
		-10,
		-80,
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	yield(tween, "tween_completed")
	$BackgroundMusic.stream = _zone.music
	$BackgroundMusic.play()
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
	tween.interpolate_property(
		$BackgroundMusic,
		"volume_db",
		-80,
		-10,
		0.3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

func start_upgrade_process(var item):
	change_screen(SCREEN.ITEM_FORGE)
	$ItemForge.start_upgrade(item)

func end_upgrade_process():
	change_screen(SCREEN.INVENTORY)

func save_and_exit():
	var resource = IdleData.new()
	resource.idle_time = OS.get_unix_time()
	ResourceSaver.save(save_path, resource)

func _notification(what):
	if what == MainLoop.NOTIFICATION_APP_RESUMED:
		get_idle_rewards()

func get_idle_rewards():
	yield(get_tree(), "idle_frame")
	print("Getting idle rewards")
	if ResourceLoader.exists(save_path):
		var elapsed_time = OS.get_unix_time() - load(save_path).idle_time
		print("Elapsed time: ", elapsed_time)
		if elapsed_time < 60:
			return
		var idle_reward = IdleReward.instance()
		add_child(idle_reward)
		idle_reward.rect_size = ScreenMeasurer.get_screen_size()
		idle_reward.set_time(elapsed_time)
		var monsters = CombatProcessor.Zone.get_monster_instances()
		for _monster in monsters:
			get_tree().root.add_child(_monster)
		var iterations = 0
		var time_per_combat = 60
		while elapsed_time > 0:
			var part = min(elapsed_time, 180 * 60)
			iterations += part / time_per_combat
			time_per_combat += 60
			elapsed_time -= part
		CombatProcessor.Zone.zone_floor += iterations
		LootManager.idle_reward_container = idle_reward
		for i in range(iterations):
			var _monster = monsters[i % monsters.size()]
			_monster.die()
			CombatProcessor.monster_died(_monster, CombatProcessor.Zone)
		LootManager.idle_reward_container = null
		for _monster in monsters:
			_monster.queue_free()
