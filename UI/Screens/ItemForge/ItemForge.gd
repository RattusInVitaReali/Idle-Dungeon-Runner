extends Screen
class_name ItemForgeUI

signal get_parts
signal upgrade_finished

const ItemConfirmInspector = preload("res://UI/Inspectors/ItemInspector/ItemConfirmInspector/ItemConfirmInspector.tscn")
const PartCompareInspector = preload("res://UI/Inspectors/PartInspector/PartConfirmInspector/PartCompareInspector/PartCompareInspector.tscn")

onready var parts = $VBoxContainer/Screen/VBoxContainer/SlottableInventory
onready var forge = $VBoxContainer/Screen/VBoxContainer/Image/ForgeImage

onready var item_creation = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation
onready var item_selection = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation/ItemSelectionInventory
onready var parts_dimm = $VBoxContainer/Screen/VBoxContainer/SlottableInventory/PartsDimm
onready var items_dimm = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation/ItemSelectionInventory/ItemSelectionDimm

onready var item_type = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation/ItemInfoBackground/VBoxContainer/ItemType
onready var item_parts = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation/ItemInfoBackground/VBoxContainer/ItemParts
onready var item_description = $VBoxContainer/Screen/VBoxContainer/Image/ItemCreation/ItemInfoBackground/VBoxContainer/ItemDescription

onready var item_upgrade = $VBoxContainer/Screen/VBoxContainer/Image/ItemUpgrade
onready var item_preview = $VBoxContainer/Screen/VBoxContainer/Image/ItemUpgrade/ItemPreviewInventory
onready var item_slot = $VBoxContainer/Screen/VBoxContainer/Image/ItemUpgrade/VBoxContainer/HBoxContainer/ItemSlot
onready var item_name = $VBoxContainer/Screen/VBoxContainer/Image/ItemUpgrade/VBoxContainer/TextureRect/ItemName

onready var button_left = $VBoxContainer/Screen/VBoxContainer/Buttons/ButtonLeft/Label
onready var button_right = $VBoxContainer/Screen/VBoxContainer/Buttons/ButtonRight/Label

var creating = false
var upgrading = false
var selecting_parts = false
var selected_item = null
var item_to_upgrade = null
var selected_parts = []

var selected_item_slot = null
var selected_part_slots = []

func _ready():
	parts.connect("inspector", self, "_on_inspector")
	item_selection.connect("item_type_selected", self, "_on_item_type_selected")
	item_preview.connect("inspector", self, "_on_inspector")
	item_slot.connect("inspector", self, "_on_inspector")

func add_part(part):
	if creating or upgrading:
		yield(self, "get_parts")
	parts.add_slottable(part)

func _on_item_type_selected(slot):
	var item = slot.slottable
	if selected_item_slot != null:
		selected_item_slot.deselect()
	slot.select()
	selected_item_slot = slot
	update_item_info(item)
	selected_item = item

func update_item_info(item : Item = null):
	if item != null:
		item_type.text = CraftingManager.ITEM_SUBTYPE.keys()[item.subtype].capitalize()
		var req_parts = ""
		for part in item.required_parts:
			req_parts += CraftingManager.PART_TYPE.keys()[part].capitalize() + " - "
		if req_parts != "":
			req_parts.erase(req_parts.length() - 3, 3)
		var opt_parts = ""
		for part in item.optional_parts:
			opt_parts += CraftingManager.PART_TYPE.keys()[part].capitalize() + " - "
		if opt_parts != "":
			opt_parts.erase(opt_parts.length() - 3, 3)
		item_parts.text = "Required parts:\n " + req_parts + "\nOptional parts:\n " + opt_parts
		item_description.text = item.description
	else:
		item_type.text = ""
		item_parts.text = ""
		item_description.text = ""

func _on_inspector(slot):
	if (!creating and !upgrading) or (upgrading and slot.slottable.get_parent() is Item) or slot.slottable is Item:
		var inspector = ._on_inspector(slot)
		if !(slot.slottable is Item):
			inspector.connect("merge", self, "_on_merge")
	elif upgrading:
		var valid_types = item_to_upgrade.required_parts.duplicate()
		valid_types.append_array(item_to_upgrade.optional_parts)
		var valid = false
		for part_type in valid_types:
			if slot.slottable.type == part_type:
				valid = true
				break
		if !valid:
			return
		var compare_to = null
		for part in item_preview.get_items_container().get_children():
			if part.type == slot.slottable.type:
				compare_to = part
				break
		var inspector = item_compare_inspector(slot.slottable, compare_to)
		var response = yield(inspector, "confirmed")
		if response:
			replace_part(slot.slottable)
			start_upgrade(item_to_upgrade)
	elif selecting_parts:
		var valid_types = selected_item.required_parts.duplicate()
		valid_types.append_array(selected_item.optional_parts)
		var valid = false
		for part_type in valid_types:
			if slot.slottable.type == part_type:
				valid = true
				break
		if !valid:
			return
		if slot in selected_part_slots:
			slot.deselect()
			selected_parts.erase(slot.slottable)
			selected_part_slots.erase(slot)
			return
		var slottable = slot.slottable
		slot.select()
		for part in selected_parts:
			if part.type == slottable.type:
				for part_slot in selected_part_slots:
					if part_slot.slottable == part:
						part_slot.deselect()
						selected_part_slots.erase(part_slot)
						break
				selected_parts.erase(part)
				break
		selected_parts.append(slottable)
		selected_part_slots.append(slot)

func _on_merge(slottable):
	var new_item = slottable.try_to_merge()
	if new_item != null:
		LootManager.get_item(new_item)

func item_confirm_inspector(part):
	var inspector = ItemConfirmInspector.instance()
	add_child(inspector)
	inspector.set_slottable(part)
	return inspector

func item_compare_inspector(part1, part2):
	var inspector = PartCompareInspector.instance()
	add_child(inspector)
	inspector.set_slottable(part1)
	inspector.set_compare_to(part2)
	return inspector

func _on_ButtonLeft_pressed():
	if upgrading:
		return
	update_item_info()
	if !creating:
		start_creation()
	else:
		end_creation()

func _on_ButtonRight_pressed():
	if upgrading:
		end_upgrade()
		emit_signal("upgrade_finished")
	if !creating or (creating and selected_item == null):
		return
	elif !selecting_parts:
		reset_part_selection()
		start_part_selection()
	else:
		create_item()

func start_creation():
	creating = true
	selecting_parts = false
	selected_item = null
	selected_parts = []
	forge.hide()
	parts_dimm.show()
	items_dimm.hide()
	item_creation.show()
	button_left.text = "Cancel"
	button_right.text = "Confirm"
	if selected_item_slot != null:
		selected_item_slot.deselect()
	for part_slot in selected_part_slots:
		part_slot.deselect()
	selected_part_slots = []

func end_creation():
	creating = false
	selecting_parts = false
	selected_item = null
	selected_parts = []
	forge.show()
	parts_dimm.hide()
	items_dimm.hide()
	item_creation.hide()
	button_left.text = "New Item"
	button_right.text = ""
	if selected_item_slot != null:
		selected_item_slot.deselect()
	for part_slot in selected_part_slots:
		part_slot.deselect()
	selected_part_slots = []
	emit_signal("get_parts")

func start_part_selection():
	selecting_parts = true
	items_dimm.show()
	parts_dimm.hide()

func reset_part_selection():
	for slot in selected_part_slots:
		slot.deselect()
	selected_parts = []
	selected_part_slots = []

func create_item():
	var new_item = CraftingManager.forge_item(selected_item, selected_parts)
	if new_item != null:
		reset_part_selection()
		var inspector = item_confirm_inspector(new_item)
		var response = yield(inspector, "confirmed")
		if response:
			LootManager.get_item(new_item)
			end_creation()
		else:
			for part in new_item.get_children():
				new_item.remove_child(part)
				LootManager.get_item(part)
			new_item.queue_free()
			emit_signal("get_parts")

func start_upgrade(var item):
	upgrading = true
	item_to_upgrade = item
	forge.hide()
	item_preview.set_item(item)
	item_upgrade.show()
	item_slot.set_slottable(item)
	item_name.text = item.slottable_name
	button_left.text = ""
	button_right.text = "Finish"

func end_upgrade():
	upgrading = false
	if item_to_upgrade.get_parent() == null:
		LootManager.get_item(item_to_upgrade)
	item_to_upgrade = null
	forge.show()
	item_preview.set_item(null)
	item_upgrade.hide()
	item_slot.set_slottable(null)
	item_name.text = ""
	button_left.text = "New Item"
	button_right.text = ""
	emit_signal("get_parts")
	emit_signal("upgrade_finished")

func replace_part(var part):
	var split_part = parts.remove_slottable(part)
	item_to_upgrade.add_part(split_part)

func _on_lost_focus():
	._on_lost_focus()
	if creating:
		end_creation()
	if upgrading:
		end_upgrade()

