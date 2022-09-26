extends Node
class_name SaverScript

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
