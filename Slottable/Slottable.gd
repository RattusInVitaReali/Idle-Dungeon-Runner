extends Node2D
class_name Slottable

enum SLOTTABLE_TYPE { MATERIAL, ITEM_PART, ITEM }

var icon
var slottable_name
export (SLOTTABLE_TYPE) var slottable_type

var rarity = CraftingManager.RARITY.BASIC

func from_lootable(lootable):
	pass
