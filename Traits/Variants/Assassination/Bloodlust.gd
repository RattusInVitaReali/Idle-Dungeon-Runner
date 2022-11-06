extends Trait
class_name Bloodlust

const damage_multi = 1.1

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	if damage_info.target.has_effect("Bleeding"):
		damage_info.phys_damage(damage_info.phys_damage * damage_multi)
		damage_info.magic_damage(damage_info.magic * damage_multi)

func description():
	return "Deal " + str((damage_multi - 1) * 100) + "% more damage to bleeding targets."
