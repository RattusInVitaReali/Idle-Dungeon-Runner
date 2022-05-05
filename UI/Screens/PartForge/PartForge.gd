extends Screen

var creating = false

onready var materials = $VBoxContainer/Screen/VBoxContainer/SlottableInventory
onready var part_selection = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartSelectionInventory

onready var part_creation = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation
onready var forge = $VBoxContainer/Screen/VBoxContainer/Image/ForgeImage

onready var part_type = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartType
onready var part_materials = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartMaterials
onready var part_description = $VBoxContainer/Screen/VBoxContainer/Image/PartCreation/PartInfoBackground/VBoxContainer/PartDescription

onready var new_part = $VBoxContainer/Screen/VBoxContainer/Buttons/NewPart/Label

func _ready():
	materials.connect("inspector", self, "_on_inspector")
	part_selection.connect("part_type_selected", self, "_on_part_type_selected")

func add_material(mat):
	materials.add_slottable(mat)

func _on_part_type_selected(part):
	update_part_info(part)

func update_part_info(part : ItemPart):
	part_type.text = CraftingManager.PART_TYPE.keys()[part.type].capitalize()
	var types = ""
	for type in part.allowed_material_types:
		types += CraftingManager.MATERIAL_TYPE.keys()[type].capitalize() + " - "
	if types != "":
		types.erase(types.length() - 3, 3)
	part_materials.text = "Allowed material types:\n" + types
	part_description.text = part.description

func _on_NewPart_pressed():
	if !creating:
		forge.hide()
		part_creation.show()
		creating = true
		new_part.text = "Cancel"
	else:
		forge.show()
		part_creation.hide()
		creating = false
		new_part.text = "New Part"
