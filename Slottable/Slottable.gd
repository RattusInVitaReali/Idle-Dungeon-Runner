extends Node2D
class_name Slottable

enum SLOTTABLE_TYPE { MATERIAL, ITEM_PART, ITEM, SKILL }

signal slottable_updated

var Slottable

var icon
var slottable_name
var quantity = 1
export (SLOTTABLE_TYPE) var slottable_type

var rarity = CraftingManager.RARITY.BASIC
var tier = 0

func _ready():
	Slottable = load("res://Slottable/Slottable.tscn")

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
	var new_slottable = load(filename).instance()
	special_copy(new_slottable)
	new_slottable.quantity(quant)
	quantity(quantity - quant)
	emit_signal("slottable_updated")
	return new_slottable

func special_copy(new_slottable):
	pass

func same_as(slottable : Slottable):
	return false
