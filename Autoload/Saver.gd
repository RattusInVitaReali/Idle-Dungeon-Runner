extends Node
class_name SaverScript

const save_path = "user://idle_data.tres"
const IdleReward = preload("res://UI/FullScreenPopup/IdleReward/IdleReward.tscn")

signal idle_reward

var save_on_exit = []

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what in [MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST, MainLoop.NOTIFICATION_APP_PAUSED]:
		save_all()
	if what in [MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST]:
		get_tree().quit()

func save_on_exit(node):
	save_on_exit.append(node)

func get_all_children(in_node, arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func save_scene(node, path):
	for child in get_all_children(node):
		if child != node and child.owner == null:
			child.owner = node
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	ResourceSaver.save(path, packed_scene)

func save_all():
	for saveable in save_on_exit:
		saveable.save_and_exit()

func get_idle_rewards():
	yield(get_tree(), "idle_frame")
	if ResourceLoader.exists(save_path):
		var elapsed_time = OS.get_unix_time() - load(save_path).idle_time
		print("Elapsed time: ", elapsed_time)
		if elapsed_time < 60:
			return
		var idle_reward = IdleReward.instance()
		emit_signal("idle_reward", idle_reward)
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
