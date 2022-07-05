extends NinePatchRect
class_name SlottableInventory

signal inspector

const Line = preload("res://UI/SlottableInventory/Line/Line.tscn")
export var Slot = preload("res://UI/Slot/Slot.tscn")

onready var lines_container = $ScrollContainer/VBoxContainer

export var line_size = 6

func add_slottable(slottable : Slottable):
	var added = false
	for _slottable in get_items_container().get_children():
		if _slottable.slottable_type == slottable.slottable_type:
			if _slottable.same_as(slottable):
				_slottable.add_quantity(slottable.quantity)
				added = true
				break
	if !added:
		get_items_container().add_child(slottable)
		slottable.connect("tree_exited", self, "update_inventory")
	update_inventory()

# DOESN'T DELETE THE ITEM!
func remove_slottable(slottable : Slottable, quantity = 1):
	var ret = slottable.split(quantity)
	return ret

static func _sort_rarity(a, b):
	if a == null or b == null:
		return false
	if a.rarity == null or b.rarity == null:
		return false
	if a.rarity > b.rarity:
		return true
	return false

static func _sort_name(a, b):
	if a == null or b == null:
		return false
	if a.slottable_name == null or b.slottable_name == null:
		return false
	if a.slottable_name < b.slottable_name:
		return true
	return false

static func _sort_tier(a, b):
	if a == null or b == null:
		return false
	if a.tier == null or b.tier == null:
		return false
	if a.tier > b.tier:
		return true
	return false

func reorder_items():
	var items = get_items_container().get_children()
	items.sort_custom(self, "_sort_tier")
	items.sort_custom(self, "_sort_name")
	items.sort_custom(self, "_sort_rarity")
	for item in get_items_container().get_children():
		get_items_container().remove_child(item)
	for item in items:
		get_items_container().add_child(item)

func update_inventory(var reorder = true):
	if reorder:
		reorder_items()
	for line in lines_container.get_children():
		lines_container.remove_child(line)
		line.queue_free()
	var lines = []
	var line = []
	var i = 0
	for slottable in get_items_container().get_children():
		if slottable.quantity == 0: # In case something gets freed next frame
			continue
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
		new_line.init(line_size, Slot)
		new_line.connect("inspector", self, "_on_inspector")
		new_line.update_line(slottable_list)

func get_items_container():
	return $Items

func _on_inspector(slot, flags):
	emit_signal("inspector", slot, flags)
