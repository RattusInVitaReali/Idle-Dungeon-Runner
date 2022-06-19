extends GameScreen

const Player = preload("res://Entities/Player/Player.tscn")

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

var deaths = 0
var timeout = 0
const timeout_per_death = 2

var monster = null
var zone = null

onready var image_1 = $Map/Image1
onready var image_2 = $Map/Image2

func _ready():
	CombatProcessor.connect("zone_changed", self, "change_zone")
	connect("player_spawned", CombatProcessor, "_on_player_spawned")
	connect("player_despawned", CombatProcessor, "_on_player_despawned")
	connect("monster_spawned", CombatProcessor, "_on_monster_spawned")
	connect("monster_arrived", CombatProcessor, "_on_monster_arrived")
	connect("monster_despawned", CombatProcessor, "_on_monster_despawned")
	measure_screen()
	image_1.position.x = screen_center_x
	image_2.position.x = screen_center_x
	spawn_player()

func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.connect("despawned", self, "_on_player_despawned")
	player.position = Vector2(screen_center_x, player_spawn_pos_x)
	player.scale = Vector2(0.25, 0.25)
	$Combat.player_spawned(player)
	emit_signal("player_spawned", player)

func spawn_monster():
	var _monster = zone.make_zone_monster()
	add_child_below_node($Map, _monster)
	_monster.connect("despawned", self, "_on_monster_despawned")
	monster = _monster
	monster.position = Vector2(screen_center_x, monster_spawn_pos_x)
	monster.scale = Vector2(0.25, 0.25)
	$Combat.monster_spawned(monster)
	emit_signal("monster_spawned", monster)

func change_zone(new_zone):
	if (CombatProcessor.in_combat):
		CombatProcessor.exit_combat()
	if CombatProcessor.Monster != null:
		CombatProcessor.Monster.queue_free()
	if zone != null:
		disconnect("monster_despawned", zone, "_on_monster_despawned")
		zone.disconnect("quest_changed", self, "_on_quest_changed")
		zone.activate_quest(false)
	zone = new_zone
	connect("monster_despawned", zone, "_on_monster_despawned")
	zone.connect("quest_changed", self, "_on_quest_changed")
	load_images()
	$Combat.zone_changed(zone)
	zone.activate_quest(true)
	update_quest(zone.quest)
	emit_signal("zone_changed")
	new_combat()

func _on_quest_changed(quest):
	quest.active = true
	update_quest(quest)

func update_quest(quest):
	$Combat.quest_changed(quest)

func increment_timeout():
	deaths += 1
	timeout += timeout_per_death

func reset_timeout():
	deaths = 0
	timeout = 0

func increment_level():
	zone.increment_level()

func decrement_level():
	zone.decrement_level()

func _on_player_despawned():
	emit_signal("player_despawned")
	increment_timeout()
	respawn_player()

func _on_monster_despawned():
	emit_signal("monster_despawned")
	new_combat()

func respawn_player():
	yield(get_tree().create_timer(timeout), "timeout")
	CombatProcessor.Player.fake_respawn()
	emit_signal("player_spawned")

func new_combat():
	reset_timeout()
	spawn_monster()

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
	if not CombatProcessor.in_combat and !CombatProcessor.Player.dead:
		move_monster(delta)
	if not CombatProcessor.in_combat and !CombatProcessor.Player.dead:
		move_map(delta)

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
	if monster != null:
		if monster.position != Vector2(screen_center_x, padding_top):
			monster.position = monster.position.move_toward(Vector2(screen_center_x, padding_top), global_speed * delta)
		else:
			emit_signal("monster_arrived")
