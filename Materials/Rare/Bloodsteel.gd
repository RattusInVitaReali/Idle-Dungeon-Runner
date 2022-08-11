extends MaterialResource
class_name Bloodsteel

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item : Item):
	if item.type == CraftingManager.ITEM_TYPE.WEAPON:
		if damage_info.bleeding_tick:
			damage_info.phys_damage *= 1.2
			damage_info.magic_damage *= 1.2

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item : Item):
	if item.type == CraftingManager.ITEM_TYPE.ARMOR:
		if damage_info.bleeding_tick:
			damage_info.phys_damage /= 1.2
			damage_info.magic_damage /= 1.2
