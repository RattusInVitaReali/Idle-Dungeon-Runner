extends NinePatchRect
class_name SlottableInventory

signal inspector

export var SlotScene = preload("res://UI/Slot/Slot.tscn")

export var columns = 6
export var allow_sorting = true

export var save_path = ""
export var force_block_save = false

export var hide_slottable_quantity = false

onready var container = $ScrollContainer/GridContainer

var ready = false

func _ready():
	if !force_block_save:
		Saver.save_on_exit(self)
	container.columns = columns
	self.load()
	ready = true

func add_slottable(slottable : Slottable, update = true):
	if slottable == null:
		return
	var added = false
	for _slottable in get_items_container().get_children():
		if _slottable.slottable_type == slottable.slottable_type:
			if _slottable.same_as(slottable):
				_slottable.quantity += slottable.quantity
				slottable.queue_free()
				added = true
				break
	if !added:
		get_items_container().add_child(slottable)
		if update:
			update_inventory()

# DOESN'T DELETE THE ITEM!
func remove_slottable(slottable : Slottable, quantity = 1):
	var ret = slottable.split(quantity)
	return ret

func clear_inventory():
	for slot in container.get_children():
		slot.queue_free()
	for item in $Items.get_children():
		item.queue_free()

static func _sort_rarity(a, b):
	if a == null or b == null:
		return false
	if a.rarity == null or b.rarity == null:
		return false
	if a.rarity < b.rarity:
		return true
	return false

static func _sort_name(a, b):
	if a == null or b == null:
		return false
	if a.slottable_name == null or b.slottable_name == null:
		return false
	if a.slottable_name > b.slottable_name:
		return true
	return false

static func _sort_tier(a, b):
	if a == null or b == null:
		return false
	if a.tier == null or b.tier == null:
		return false
	if a.tier < b.tier:
		return true
	return false

static func _sort_type(a, b):
	if a == null or b == null:
		return false
	if a.slottable_type == null or b.slottable_type == null:
		return false
	if a.slottable_type < b.slottable_type:
		return true
	return false

static func _sort_locked(a, b):
	if a == null or b == null:
		return false
	if a.locked == null or b.locked == null:
		return false
	if a.locked and !b.locked:
		return true
	return false

static func _sort_part_type(a, b):
	if a == null or b == null:
		return false
	if a.type == null or b.type == null:
		return false
	if a.type > b.type:
		return true
	return false

static func _sort_item_type(a, b):
	if a == null or b == null:
		return false
	if a.type == null or b.type == null:
		return false
	if a.type > b.type:
		return true
	return false

func sort(array, func_name):
	var func_ref = FuncRef.new()
	func_ref.set_instance(self)
	func_ref.set_function(func_name)
	var swapped = true
	while swapped:
		var i = 0
		swapped = false
		while i < array.size() - 1:
			if func_ref.call_func(array[i], array[i + 1]):
				var temp = array[i]
				array[i] = array[i + 1]
				array[i + 1] = temp
				swapped = true
			i += 1

func reorder_items():
	if !ready:
		return
	var items = get_sorted_order()
	for item in items:
		get_items_container().remove_child(item)
	for item in items:
		get_items_container().add_child(item)

func get_sorted_order():
	var items = get_items_container().get_children()
	sort(items, "_sort_tier")
	sort(items, "_sort_name")
	sort(items, "_sort_rarity")
	sort(items, "_sort_type")
	return items

func reorder_slots(var reorder_items = false):
	if reorder_items and allow_sorting:
		reorder_items()
	var ordered_slots = []
	for item in get_items_container().get_children():
		for slot in container.get_children():
			if slot.slottable == item:
				ordered_slots.append(slot)
				break
	for slot in container.get_children():
		container.remove_child(slot)
	for slot in ordered_slots:
		container.add_child(slot)
		slot.update_slot()

func update_inventory():
	if allow_sorting:
		reorder_items()
	for slot in container.get_children():
		slot.queue_free()
	if get_items_container() == null:
		return
	for slottable in get_items_container().get_children():
		if slottable.quantity == 0: # In case something gets freed next frame
			continue
		var slot = SlotScene.instance()
		if hide_slottable_quantity:
			slot.hide_quantity = true
		container.add_child(slot)
		slot.set_slottable(slottable)
		slot.connect("inspector", self, "_on_inspector")

func get_items_container():
	return $Items

func get_slots():
	return container.get_children()

func _on_inspector(slot):
	emit_signal("inspector", slot)

func load():
	if save_path != "" and ResourceLoader.exists(save_path):
		var items_scene = load(save_path)
		var items = items_scene.instance()
		for item in items.get_children():
			items.remove_child(item)
			$Items.add_child(item)
			item.load()
		items.queue_free()
		update_inventory()

func save_and_exit():
	if get_items_container() == null:
		return
	if save_path != "":
		Saver.save_scene($Items, save_path)
