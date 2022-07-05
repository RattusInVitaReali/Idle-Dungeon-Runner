extends Screen
class_name PartForgeUI

signal creation_finished

const PartConfirmInspector = preload("res://UI/Inspectors/PartInspector/PartConfirmInspector/PartConfirmInspector.tscn")

onready var materials = $VBoxContainer/Screen/VBoxContainer/SlottableInventory
onready var part_selection = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartSelectionInventory

onready var part_creation = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation
onready var forge = $VBoxContainer/Screen/VBoxContainer/Image/ForgeImage
onready var materials_dimm = $VBoxContainer/Screen/VBoxContainer/SlottableInventory/MaterialsDimm
onready var parts_dimm = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartSelectionInventory/PartSelectionDimm

onready var part_type = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartType
onready var part_materials = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartMaterials
onready var part_description = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartDescription

onready var button_left = $VBoxContainer/Screen/VBoxContainer/Buttons/ButtonLeft/Label
onready var button_right = $VBoxContainer/Screen/VBoxContainer/Buttons/ButtonRight/Label

var creating = false
var selecting_material = false
var selected_part = null
var selected_material = null

var selected_part_slot = null

func _ready():
	materials.connect("inspector", self, "_on_inspector")
	part_selection.connect("part_type_selected", self, "_on_part_type_selected")

func add_material(mat):
	if creating:
		yield(self, "creation_finished")
	materials.add_slottable(mat)

func _on_part_type_selected(slot):
	var part = slot.slottable
	if selected_part_slot != null:
		selected_part_slot.deselect()
	slot.select()
	selected_part_slot = slot
	update_part_info(part)
	selected_part = part

func update_part_info(part : ItemPart = null):
	if part != null:
		part_type.text = CraftingManager.PART_TYPE.keys()[part.type].capitalize()
		var types = ""
		for type in part.allowed_material_types:
			types += CraftingManager.MATERIAL_TYPE.keys()[type].capitalize() + " - "
		if types != "":
			types.erase(types.length() - 3, 3)
		part_materials.text = "Cost: " + str(part.cost) + "\n" + "Allowed material types:\n" + types
		part_description.text = part.description
	else:
		part_type.text = ""
		part_materials.text = ""
		part_description.text = ""

func _on_inspector(slot, flags):
	if !creating:
		._on_inspector(slot, flags)
		inspector.connect("merge", self, "_on_merge")
	elif selecting_material:
		var slottable = slot.slottable
		var new_part = CraftingManager.try_to_forge_part(selected_part, slottable)
		if new_part != null:
			var insp = part_confirm_inspector(new_part)
			var response = yield(insp, "confirmed")
			if response:
				LootManager.get_item(CraftingManager.actually_forge_part(selected_part, slottable))
				new_part.queue_free()
				end_creation()
			new_part.queue_free()

func _on_merge(slottable):
	var new_item = slottable.try_to_merge()
	if new_item != null:
		LootManager.get_item(new_item)

func part_confirm_inspector(part):
	inspector = PartConfirmInspector.instance()
	add_child(inspector)
	inspector.set_slottable(part)
	return inspector

func _on_ButtonLeft_pressed():
	update_part_info()
	if !creating:
		start_creation()
	else:
		end_creation()

func _on_ButtonRight_pressed():
	if !creating or (creating and selected_part == null):
		return
	else: 
		start_material_selection()

func start_creation():
	creating = true
	selecting_material = false
	selected_part = null
	selected_material = null
	forge.hide()
	materials_dimm.show()
	parts_dimm.hide()
	part_creation.show()
	button_left.text = "Cancel"
	button_right.text = "Confirm"
	if selected_part_slot != null:
		selected_part_slot.deselect()

func end_creation():
	creating = false
	selecting_material = false
	selected_part = null
	selected_material = null
	forge.show()
	materials_dimm.hide()
	parts_dimm.hide()
	part_creation.hide()
	button_left.text = "New Part"
	button_right.text = ""
	if selected_part_slot != null:
		selected_part_slot.deselect()
	emit_signal("creation_finished")

func start_material_selection():
	selecting_material = true
	parts_dimm.show()
	materials_dimm.hide()

func _on_lost_focus():
	._on_lost_focus()
	end_creation()
