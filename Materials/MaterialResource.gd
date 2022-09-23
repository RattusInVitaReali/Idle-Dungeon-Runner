extends Resource
class_name MaterialResource

enum ICON_TEXTURE { INGOT, LOG, CLUMP, LEATHER }

const icon_texture_dict = {
	ICON_TEXTURE.INGOT : preload("res://RESOURCES/Materials/Ingot.png"),
	ICON_TEXTURE.LOG : preload("res://RESOURCES/Materials/Log.png"),
	ICON_TEXTURE.CLUMP : preload("res://RESOURCES/Materials/Clump.png"),
	ICON_TEXTURE.LEATHER : preload("res://RESOURCES/Materials/Leather.png")
}

export (ICON_TEXTURE) var icon_texture
export (Color) var icon_color

export (String) var slottable_name
export (String) var prefix
export (String) var special_weapon
export (String) var special_armor
export (String) var special_accessory

export (CraftingManager.MATERIAL_TYPE) var type
export (CraftingManager.RARITY) var rarity

export var stats = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

func get_icon():
	return icon_texture_dict[icon_texture]

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass
