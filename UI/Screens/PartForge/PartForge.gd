extends Screen
class_name PartForgeUI

signal get_materials

const PartConfirmInspector = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/PartInspector/PartConfirmInspector/PartConfirmInspector.tscn")
const CraftingMaterial = preload("res://Materials/CraftingMaterial.tscn")

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
	LootManager.connect("item_acquired", self, "_on_item_acquired")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL:
		add_material(item)

func _notification(what):
	if what == NOTIFICATION_READY:
		if CraftingManager.debug:
			for res in get_all_files("res://Materials", "tres"):
				var mat = CraftingMaterial.instance()
				mat.set_mat(load(res))
				mat.quantity = 5000
				add_material(mat)

func get_all_files(path: String, file_ext := "", files := []):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				files = get_all_files(dir.get_current_dir().plus_file(file_name), file_ext, files)
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_name = dir.get_next()
					continue
				files.append(dir.get_current_dir().plus_file(file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)
	return files

func add_material(mat):
	if creating:
		yield(self, "get_materials")
	materials.add_slottable(mat)

func _on_part_type_selected(slot):
	var part = slot.slottable
	if selected_part_slot != null:
		selected_part_slot.deselect()
	slot.select()
	selected_part_slot = slot
	update_part_info(part)
	if part.locked:
		selected_part = null
	else:
		selected_part = part

func update_part_info(part : ItemPart = null):
	if part != null:
		if part.locked:
			part_type.text = "LOCKED"
			part_materials.text = "This part is LOCKED! Try defeating stronger enemies to unlock it."
			part_description.text = ""
			part_description.hide()
		else:
			part_type.text = CraftingManager.PART_TYPE.keys()[part.type].capitalize()
			var types = ""
			for type in part.allowed_material_types:
				types += CraftingManager.MATERIAL_TYPE.keys()[type].capitalize() + " - "
			if types != "":
				types.erase(types.length() - 3, 3)
			part_materials.text = "Cost: " + str(part.cost) + "\n" + "Allowed material types:\n" + types
			part_description.text = part.description
			part_description.show()
	else:
		part_type.text = ""
		part_materials.text = ""
		part_description.text = ""

func _on_inspector(slot):
	if !creating:
		._on_inspector(slot)
	elif selecting_material:
		var mat = slot.slottable
		if selected_part.cost > mat.quantity:
			return
		var new_part = selected_part.duplicate() 
		add_child(new_part)
		mat.quantity += selected_part.cost
		new_part.set_mat(mat.split(selected_part.cost))
		var inspector = part_confirm_inspector(new_part, mat)
		var response = yield(inspector, "confirmed") # response = [confirmed, tier, cost]
		if response[0]:
			remove_child(new_part)
			LootManager.get_item(new_part)
			mat.quantity -= response[2]
			end_creation()
		else:
			new_part.queue_free()

func part_confirm_inspector(part, mat):
	inspector = PartConfirmInspector.instance()
	add_child(inspector)
	inspector.set_slottable(part)
	inspector.set_mat(mat)
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
		selected_part_slot = null

func end_creation():
	show_all_mats()
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
		selected_part_slot = null
	emit_signal("get_materials")

func hide_other_mats():
	for slot in materials.get_slots():
		if !(slot.slottable.type in selected_part.allowed_material_types):
			slot.hide()
			continue
		if selected_part.cost > slot.slottable.quantity:
			slot.set_quantity_color(Color.red)

func show_all_mats():
	for slot in materials.get_slots():
		slot.show()
		slot.set_quantity_color(Color.white)

func start_material_selection():
	selecting_material = true
	hide_other_mats()
	parts_dimm.show()
	materials_dimm.hide()

func on_lost_focus():
	.on_lost_focus()
	end_creation()
