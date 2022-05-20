extends GameScreen

const Player = preload("res://Entities/Player/Player.tscn")
const ZoneForest = preload("res://Zones/Forest/Forest.tscn")

signal monster_spawned
signal monster_arrived
signal monster_despawned

signal player_spawned
signal player_despawned

signal zone_changed

var screen_width = 1080
var screen_height = 1920
var screen_center_x = 540
var padding_bottom = 900
var padding_top = 600
var scale_value = 1
var global_speed = 300

var monster_spawn_pos_x = -500
var player_spawn_pos_x = 1020

var enemy = null
var zone = null

onready var image_1 = $Map/Image1
onready var image_2 = $Map/Image2

func _ready():
	connect("player_spawned", CombatProcessor, "_on_player_spawned")
	connect("player_despawned", CombatProcessor, "_on_player_despawned")
	connect("monster_spawned", CombatProcessor, "_on_monster_spawned")
	connect("monster_arrived", CombatProcessor, "_on_monster_arrived")
	connect("monster_despawned", CombatProcessor, "_on_monster_despawned")
	measure_screen()
	image_1.position.x = screen_center_x
	image_2.position.x = screen_center_x
	change_zone(ZoneForest)
	spawn_player()
	spawn_monster()

func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.connect("despawned", self, "_on_player_despawned")
	player.position = Vector2(screen_center_x, player_spawn_pos_x)
	player.scale = Vector2(0.25, 0.25)
	emit_signal("player_spawned", player)

func spawn_monster():
	var _monster = zone.make_zone_monster()
	add_child_below_node($Zone, _monster)
	_monster.connect("despawned", self, "_on_monster_despawned")
	enemy = _monster
	enemy.position = Vector2(screen_center_x, monster_spawn_pos_x)
	enemy.scale = Vector2(0.25, 0.25)
	emit_signal("monster_spawned", enemy)

func _on_player_despawned():
	emit_signal("player_despawned")

func _on_monster_despawned():
	emit_signal("monster_despawned")
	new_combat()

func new_combat():
	spawn_monster()

func change_zone(zone_scene):
	for zone in $Zone.get_children():
		zone.queue_free()
	var new_zone = zone_scene.instance()
	$Zone.add_child(new_zone)
	zone = new_zone
	load_images()
	CombatProcessor.emit_signal("zone_changed", zone)

func load_images():
	image_1.texture = zone.texture
	image_2.texture = zone.texture

func measure_screen():
	screen_height = get_viewport().size.y
	screen_width = get_viewport().size.x
	scale_value = screen_width / 1080
	scale = Vector2(scale_value, scale_value)
	screen_center_x = (screen_width / scale_value) / 2

var f2_on_top = true
var f1_on_top = false

func _process(delta):
	if not CombatProcessor.in_combat and CombatProcessor.Player != null:
		move_map(delta)
		move_monster(delta)

func move_map(delta):
	if f2_on_top:
		image_1.position = image_1.position.move_toward(Vector2(screen_center_x, 3520), global_speed * delta)
		image_2.position = image_2.position.move_toward(Vector2(screen_center_x, 320), global_speed * delta)
		if image_1.position == Vector2(screen_center_x, 3520):
			image_1.position = Vector2(screen_center_x, -2880)
			f1_on_top = true
			f2_on_top = false
	elif f1_on_top:
		image_2.position = image_2.position.move_toward(Vector2(screen_center_x, 3520), global_speed * delta)
		image_1.position = image_1.position.move_toward(Vector2(screen_center_x, 320), global_speed * delta)
		if image_2.position == Vector2(screen_center_x, 3520):
			image_2.position = Vector2(screen_center_x, -2880)
			f2_on_top = true
			f1_on_top = false

# emit_signal("monster_arrived"), CombatProcessor starts the combat
func move_monster(delta):
	if enemy != null:
		if enemy.position != Vector2(screen_center_x, padding_top):
			enemy.position = enemy.position.move_toward(Vector2(screen_center_x, padding_top), global_speed * delta)
		else:
			emit_signal("monster_arrived")
