extends Node2D
class_name CombatScreen

const PlayerScene = preload("res://Entities/Player/Player.tscn")
var scale_value = 1
var global_speed = 300

var monster_spawn_y = -500
var monster_combat_y = 850
var player_bottom_y = 800

var timeout = 2

var player : Player = null
var monster : Monster = null
var zone : Zone = null

onready var image_1 = $Map/Image1
onready var image_2 = $Map/Image2

func _ready():
	CombatProcessor.connect("zone_changed", self, "change_zone")
	spawn_player()

func spawn_player():
	player = PlayerScene.instance()
	if Player.save_path != "":
		if ResourceLoader.exists(Player.save_path):
			player.queue_free()
			player = load(Player.save_path).instance()
			player.load()
	add_child_below_node($Map, player)
	player.connect("despawned", self, "_on_player_despawned")
	player.position = Vector2(540, ScreenMeasurer.height - player_bottom_y)
	player.scale *= Vector2(0.33, 0.33)
	CombatProcessor.player_spawned(player)

func spawn_monster():
	var _monster = zone.make_zone_monster()
	monster = _monster
	add_child_below_node($Map, monster)
	monster.connect("despawned", self, "_on_monster_despawned")
	monster.connect("died", self, "_on_monster_died")
	monster.position = Vector2(540, monster_spawn_y)
	monster.scale.x /= 3
	monster.scale.y /= 3
	CombatProcessor.monster_spawned(monster)

func change_zone(new_zone):
	if (CombatProcessor.in_combat):
		CombatProcessor.exit_combat()
	if monster != null:
		monster.queue_free()
	zone = new_zone
	load_images()
	new_combat()

func yeet_monster():
	if monster != null:
		yield(get_tree().create_timer(timeout / 2), "timeout")
		if monster == null:
			return
		yield(CombatProcessor, "player_spawned")
		if monster != null:
			monster.queue_free()
			monster = null

func _on_player_despawned():
	CombatProcessor.player_despawned()
	yeet_monster()
	respawn_player()

func _on_monster_died():
	CombatProcessor.monster_died(monster, zone)

func _on_monster_despawned():
	yield(zone, "zone_updated") # Hack to force zone to process the signal first
	CombatProcessor.monster_despawned()
	monster = null
	new_combat()

func respawn_player():
	yield(get_tree().create_timer(timeout), "timeout")
	player.fake_respawn()
	CombatProcessor.player_spawned(player)
	new_combat()

func new_combat():
	spawn_monster()

func load_images():
	image_1.texture = zone.texture
	image_2.texture = zone.texture


func _process(delta):
	if not CombatProcessor.in_combat and !player.dead:
		move_monster(delta)
	if not CombatProcessor.in_combat and !player.dead:
		move_map(delta)

onready var bg_top = image_2
onready var bg_bot = image_1

func move_map(delta):
	bg_top.position = bg_top.position.move_toward(Vector2(-260, 0), global_speed * delta)
	bg_bot.position = bg_bot.position.move_toward(Vector2(-260, 3200), global_speed * delta)
	if bg_top.position == Vector2(-260, 0):
		bg_bot.position = Vector2(-260, -3200)
		var temp = bg_top
		bg_top = bg_bot
		bg_bot = temp

func move_monster(delta):
	if monster != null:
		if monster.position != Vector2(540, monster_combat_y):
			monster.position = monster.position.move_toward(Vector2(540, monster_combat_y), global_speed * delta)
		else:
			CombatProcessor.enter_combat()
			player.enter_combat()
			monster.enter_combat()
