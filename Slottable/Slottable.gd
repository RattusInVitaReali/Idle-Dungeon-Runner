extends Node2D
class_name Slottable

enum SLOTTABLE_TYPE { MATERIAL, ITEM_PART, ITEM, SKILL }

var icon
var slottable_name
var quantity = 1
export (SLOTTABLE_TYPE) var slottable_type

var rarity = CraftingManager.RARITY.BASIC
var tier = 0

func from_lootable(lootable):
	pass

func quantity(quant):
	quantity = quant;
	if quantity == 0:
		queue_free()
	return self

func add_quantity(amount):
	quantity(quantity + amount)

func split(quant):
	if quant > quantity: 
		return null
	var new_slottable = self.duplicate()
	for property in get_script().get_script_property_list():
		new_slottable.set(property.name, get(property.name))
	special_copy(new_slottable)
	new_slottable.quantity(quant)
	quantity(quantity - quant)
	return new_slottable

func special_copy(new_slottable):
	pass
