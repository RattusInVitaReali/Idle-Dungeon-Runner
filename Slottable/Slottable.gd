extends Node2D
class_name Slottable

enum SLOTTABLE_TYPE { MATERIAL, ITEM_PART, ITEM }

var icon
export (SLOTTABLE_TYPE) var slottable_type

var quantity = 1
var rarity = CraftingManager.RARITY.BASIC
