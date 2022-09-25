extends FullScreenPopup
class_name SlottableInspector

onready var slottable_name = $Panel/VBoxContainer/Name
onready var rarity = $Panel/VBoxContainer/Rarity
onready var icon = $Panel/VBoxContainer/Image/Icon

var slot : Slot
var slottable : Slottable

func set_slot(_slot):
	slot = _slot
	if slot == null:
		set_slottable(null)
		return
	set_slottable(slot.slottable)

func set_slottable(_slottable):
	slottable = _slottable
	update_name()
	update_rarity()
	update_icon()

func update_name():
	slottable_name.text = slottable.slottable_name

func update_rarity():
	rarity.text = CraftingManager.RARITY.keys()[slottable.rarity].capitalize() + " "
	match slottable.slottable_type:
		Slottable.SLOTTABLE_TYPE.ITEM:
			rarity.text += CraftingManager.ITEM_SUBTYPE.keys()[slottable.subtype].capitalize()
		Slottable.SLOTTABLE_TYPE.ITEM_PART:
			rarity.text += CraftingManager.PART_TYPE.keys()[slottable.type].capitalize()
		Slottable.SLOTTABLE_TYPE.MATERIAL:
			rarity.text += CraftingManager.MATERIAL_TYPE.keys()[slottable.type].capitalize()
		Slottable.SLOTTABLE_TYPE.SKILL:
			rarity.text += "Skill"

func update_icon():
	icon.set_slottable(slottable)

