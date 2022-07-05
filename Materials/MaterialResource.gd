extends Resource
class_name MaterialResource

enum ICON_TEXTURE { INGOT, LOG }

const icon_texture_dict = {
	ICON_TEXTURE.INGOT: preload("res://_Resources/Materials/Ingot.png"),
	ICON_TEXTURE.LOG: preload("res://_Resources/Materials/Log.png")
}

export (ICON_TEXTURE) var icon_texture
export (Color) var icon_color

export (String) var slottable_name
export (String) var prefix
export (String) var special_weapon
export (String) var special_armor

export (CraftingManager.MATERIAL_TYPE) var type
export (CraftingManager.RARITY) var rarity
export (CraftingManager.MATERIAL_WEIGHT) var weight
export (int) var tier
export (int) var durability

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
