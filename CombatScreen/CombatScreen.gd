extends Node2D
class_name CombatScreen

const PlayerScene = preload("res://Entities/Player/Player.tscn")
const IdleReward = preload("res://UI/FullScreenPopup/IdleReward/IdleReward.tscn")

const save_path = "user://idle_data.tres"

signal idle_reward

var padding_bottom = 900
var padding_top = 600
var scale_value = 1
var global_speed = 300

var monster_spawn_pos_x = -500
var player_spawn_pos_x = 1020

var timeout = 2

var player : Player = null
var monster : Monster = null
var zone : Zone = null

var got_idle_rewards = false

onready var image_1 = $Map/Image1
onready var image_2 = $Map/Image2

func _ready():
	Saver.save_on_exit(self)
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
	player.position = Vector2(540, player_spawn_pos_x)
	player.scale = Vector2(0.25, 0.25)
	CombatProcessor.player_spawned(player)

func spawn_monster():
	var _monster = zone.make_zone_monster()
	monster = _monster
	add_child_below_node($Map, monster)
	monster.connect("despawned", self, "_on_monster_despawned")
	monster.connect("died", self, "_on_monster_died")
	monster.position = Vector2(540, monster_spawn_pos_x)
	monster.scale.x /= 4
	monster.scale.y /= 4
	CombatProcessor.monster_spawned(monster)

func change_zone(new_zone):
	if (CombatProcessor.in_combat):
		CombatProcessor.exit_combat()
	if monster != null:
		monster.queue_free()
	zone = new_zone
	load_images()
	new_combat()
	check_idle_rewards()

func yeet_monster():
	if monster != null:
		yield(get_tree().create_timer(timeout / 2), "timeout")
		if monster == null:
			return
		monster.yeet()
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
		if monster.position != Vector2(540, padding_top):
			monster.position = monster.position.move_toward(Vector2(540, padding_top), global_speed * delta)
		else:
			CombatProcessor.enter_combat()
			player.enter_combat()
			monster.enter_combat()

func check_idle_rewards():
	if !got_idle_rewards:
		get_idle_rewards()
		got_idle_rewards = true

func get_idle_rewards():
	if ResourceLoader.exists(save_path):
		var idle_reward = IdleReward.instance()
		emit_signal("idle_reward", idle_reward)
		idle_reward.rect_size = ScreenMeasurer.get_screen_size()
		var elapsed_time = OS.get_unix_time() - load(save_path).idle_time
		idle_reward.set_time(elapsed_time)
		var monsters = zone.get_monster_instances()
		for _monster in monsters:
			add_child(_monster)
		var iterations = int(elapsed_time / 60)
		zone.zone_floor += iterations
		LootManager.idle_reward_container = idle_reward
		for i in range(iterations):
			var _monster = monsters[i % monsters.size()]
			_monster.die()
			CombatProcessor.monster_died(monster, zone)
		LootManager.idle_reward_container = null
		for _monster in monsters:
			_monster.queue_free()

func save_and_exit():
	var resource = IdleData.new()
	resource.idle_time = OS.get_unix_time()
	ResourceSaver.save(save_path, resource)
