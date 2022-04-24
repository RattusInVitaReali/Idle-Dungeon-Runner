extends Resource
class_name MaterialResource

export (Texture) var icon

export (String) var material_name
export (String) var prefix
export (String) var special_weapon
export (String) var special_armor

export (CraftingManager.MATERIAL_TYPE) var type
export (CraftingManager.RARITY) var rarity
export (CraftingManager.MATERIAL_WEIGHT) var weight
export (int) var tier
export (int) var durability

export var stats = { "phys_damage": 0.0, "magic_damage": 0.0, "phys_protection": 0.0, "magic_protection": 0.0, 
					"max_hp": 0, "crit_chance": 0.0, "crit_multi": 0.0 }

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	pass
