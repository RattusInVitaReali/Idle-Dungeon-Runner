extends Node

var save_me = []

func _ready():
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		for saveable in save_me:
			saveable.save_and_exit()
		get_tree().quit()

func save(node):
	save_me.append(node)

func get_all_children(in_node, arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr
