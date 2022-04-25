extends NinePatchRect

signal inspector

const Line = preload("res://UI/SlottableInventory/Line/Line.tscn")

onready var lines_container = $ScrollContainer/VBoxContainer

func add_item(_item):
	var added = false
	if _item.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
		for item in $Items.get_children():
			if item.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
				if item.same_as(_item):
					item.add_quantity(_item.quantity)
					added = true
					break
	if !added:
		$Items.add_child(_item)
	update_inventory()

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
		new_line.connect("inspector", self, "_on_inspector")
		new_line.update_line(item_list)

func _on_inspector(inspector):
	emit_signal("inspector", inspector)
