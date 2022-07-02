extends Resource
class_name MaterialResource

export (Texture) var icon

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

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass
