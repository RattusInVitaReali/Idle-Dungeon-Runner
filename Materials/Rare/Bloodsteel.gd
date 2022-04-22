extends CraftingMaterial

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item : Item):
	if item.type == CraftingProcessor.ITEM_TYPE.WEAPON:
		if damage_info.bleeding_tick:
			damage_info.phys_damage *= 2
			damage_info.magic_damage *= 2
