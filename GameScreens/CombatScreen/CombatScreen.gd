extends GameScreen
class_name CombatScreen

const PlayerScene = preload("res://Entities/Player/Player.tscn")
const IdleReward = preload("res://UI/IdleReward/IdleReward.tscn")

const save_path = "user://idle_data.tres"

var screen_width = 1080
var screen_height = 1920
var screen_center_x = 540
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
	measure_screen()
	image_1.position.x = screen_center_x
	image_2.position.x = screen_center_x
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
	player.position = Vector2(screen_center_x, player_spawn_pos_x)
	player.scale = Vector2(0.25, 0.25)
	CombatProcessor.player_spawned(player)

func spawn_monster():
	var _monster = zone.make_zone_monster()
	monster = _monster
	add_child_below_node($Map, monster)
	monster.connect("despawned", self, "_on_monster_despawned")
	monster.connect("died", self, "_on_monster_died")
	monster.position = Vector2(screen_center_x, monster_spawn_pos_x)
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

func measure_screen():
	screen_height = get_viewport().size.y
	screen_width = get_viewport().size.x
	scale_value = screen_width / 1080
	scale = Vector2(scale_value, scale_value)
	screen_center_x = (screen_width / scale_value) / 2

var f2_on_top = true
var f1_on_top = false

func _process(delta):
	if not CombatProcessor.in_combat and !player.dead:
		move_monster(delta)
	if not CombatProcessor.in_combat and !player.dead:
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

func move_monster(delta):
	if monster != null:
		if monster.position != Vector2(screen_center_x, padding_top):
			monster.position = monster.position.move_toward(Vector2(screen_center_x, padding_top), global_speed * delta)
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
		$CanvasLayer.add_child(idle_reward)
		idle_reward.rect_size = Vector2(1080, 1920)
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
