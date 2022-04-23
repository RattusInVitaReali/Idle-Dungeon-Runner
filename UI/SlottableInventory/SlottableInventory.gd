extends NinePatchRect

const Line = preload("res://UI/SlottableInventory/Line/Line.tscn")

onready var lines_container = $ScrollContainer/VBoxContainer

func add_item(item):
	$Items.add_child(item)

func update_inventory():
	for line in lines_container.get_children():
		lines_container.remove_child(line)
	var lines = []
	var line = []
	var i = 0
	for item in $Items.get_children():
		line.append(item)
		i += 1
		if i == 6:
			lines.append(line)
			line = []
			i = 0
	if i != 0:
		lines.append(line)
	for item_list in lines:
		var new_line = Line.instance()
		lines_container.add_child(new_line)
		new_line.update_line(item_list)
