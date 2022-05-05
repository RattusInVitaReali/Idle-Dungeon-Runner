extends NinePatchRect
class_name SlottableInventory

signal inspector

const Line = preload("res://UI/SlottableInventory/Line/Line.tscn")

onready var lines_container = $ScrollContainer/VBoxContainer

export var line_size = 6

func add_slottable(_slottable):
	var added = false
	if _slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
		for slottable in $Items.get_children():
			if slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
				if slottable.same_as(_slottable):
					slottable.add_quantity(_slottable.quantity)
					added = true
					break
	if !added:
		$Items.add_child(_slottable)
	update_inventory()

func remove_slottable(slottable, quantity = 1):
	if slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
		slottable.quantity -= quantity
		if slottable.quantity == 0:
			$Items.remove_child(slottable)
	else:
		$Items.remove_child(slottable)
	update_inventory()

func update_inventory():
	for line in lines_container.get_children():
		lines_container.remove_child(line)
	var lines = []
	var line = []
	var i = 0
	for slottable in $Items.get_children():
		line.append(slottable)
		i += 1
		if i == line_size:
			lines.append(line)
			line = []
			i = 0
	if i != 0:
		lines.append(line)
	for slottable_list in lines:
		var new_line = Line.instance()
		lines_container.add_child(new_line)
		new_line.init(line_size)
		new_line.connect("inspector", self, "_on_inspector")
		new_line.update_line(slottable_list)

func _on_inspector(slottable, gear):
	emit_signal("inspector", slottable, gear)
