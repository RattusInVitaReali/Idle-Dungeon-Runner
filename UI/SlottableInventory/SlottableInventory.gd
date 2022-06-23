extends NinePatchRect
class_name SlottableInventory

signal inspector

const Line = preload("res://UI/SlottableInventory/Line/Line.tscn")
export var Slot = preload("res://UI/Slot/Slot.tscn")

onready var lines_container = $ScrollContainer/VBoxContainer

export var line_size = 6

func add_slottable(_slottable):
	var added = false
	if _slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL or _slottable.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM_PART:
		for slottable in $Items.get_children():
			if slottable.slottable_type == _slottable.slottable_type:
				if slottable.same_as(_slottable):
					slottable.add_quantity(_slottable.quantity)
					added = true
					break
	if !added:
		$Items.add_child(_slottable)
	update_inventory()

func remove_slottable(slottable, quantity = 1):
	if slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL or slottable.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM_PART:
		slottable.quantity -= quantity
		if slottable.quantity == 0:
			$Items.remove_child(slottable)
	else:
		$Items.remove_child(slottable)
	update_inventory()

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
	var items = $Items.get_children()
	items.sort_custom(self, "_sort_tier")
	items.sort_custom(self, "_sort_name")
	items.sort_custom(self, "_sort_rarity")
	for item in $Items.get_children():
		$Items.remove_child(item)
	for item in items:
		$Items.add_child(item)

func update_inventory():
	reorder_items()
	for line in lines_container.get_children():
		lines_container.remove_child(line)
		line.queue_free()
	var lines = []
	var line = []
	var i = 0
	for slottable in get_items_container():
		if slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL or slottable.slottable_type == Slottable.SLOTTABLE_TYPE.ITEM_PART:
			if slottable.quantity == 0:
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
	return $Items.get_children()

func _on_inspector(slot, flags):
	emit_signal("inspector", slot, flags)
