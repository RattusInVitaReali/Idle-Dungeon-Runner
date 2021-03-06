extends NinePatchRect
class_name SlottableInventory

signal inspector

export var SlotScene = preload("res://UI/Slot/Slot.tscn")

export var columns = 6
export var allow_sorting = true

onready var container = $ScrollContainer/GridContainer

func _ready():
	container.columns = columns

func add_slottable(slottable : Slottable, update = true):
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
		if update:
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
	for item in items:
		item.disconnect("tree_exited", self, "update_inventory")
	items.sort_custom(self, "_sort_tier")
	items.sort_custom(self, "_sort_name")
	items.sort_custom(self, "_sort_rarity")
	for item in get_items_container().get_children():
		get_items_container().remove_child(item)
	for item in items:
		get_items_container().add_child(item)
	for item in items:
		item.connect("tree_exited", self, "update_inventory")


func update_inventory(var reorder = false):
	if allow_sorting and reorder:
		reorder_items()
	for slot in container.get_children():
		slot.queue_free()
	if get_items_container() == null:
		return
	for slottable in get_items_container().get_children():
		if slottable.quantity == 0: # In case something gets freed next frame
			continue
		var slot = SlotScene.instance()
		container.add_child(slot)
		slot.set_slottable(slottable)
		slot.connect("inspector", self, "_on_inspector")

func get_items_container():
	return $Items

func _on_inspector(slot):
	emit_signal("inspector", slot)
