extends Node2D
class_name Slottable

enum SLOTTABLE_TYPE { MATERIAL, ITEM_PART, ITEM, SKILL, EXPERIENCE, GLOBAL_RESOURCE }

signal slottable_updated
signal unlocked

var Slottable

export (Texture) var icon
export (Color) var icon_color = Color(1, 1, 1, 1)
export (String) var slottable_name
export (int) var quantity = 1 setget set_quantity
export (SLOTTABLE_TYPE) var slottable_type

export (CraftingManager.RARITY) var rarity = CraftingManager.RARITY.BASIC
export (int) var tier = 0

export var unlock_zone_name = ""
export var unlock_monster_base_name = ""
export var unlock_signal_level = 0
export (bool) var locked = false
export (String) var progression_unlock_func_name = ""

func _ready():
	Slottable = load("res://Slottable/Slottable.tscn")

func from_lootable(lootable):
	pass

func set_quantity(quant):
	quantity = quant;
	emit_signal("slottable_updated")
	if quantity == 0:
		queue_free()
	return self

func split(quant):
	if quant > quantity: 
		return null
	var new_slottable = load(filename).instance()
	special_copy(new_slottable)
	new_slottable.quantity = quant
	self.quantity = quantity - quant
	emit_signal("slottable_updated")
	return new_slottable

func special_copy(new_slottable):
	pass

func same_as(slottable : Slottable):
	return false

func load():
	pass

func lock():
	if unlock_zone_name != "" or unlock_monster_base_name != "":
		locked = true
		Progression.connect("progression_monster_died", self, "try_unlock")
		connect("unlocked", Progression, progression_unlock_func_name)
	else:
		locked = false
	emit_signal("slottable_updated")

func try_unlock(monster, zone):
	if monster.base_name == unlock_monster_base_name or zone.zone_name == unlock_zone_name:
		if monster.level >= unlock_signal_level:
			unlock()

func unlock():
	locked = false
	emit_signal("unlocked", self)
	Progression.disconnect("progression_monster_died", self, "try_unlock")
