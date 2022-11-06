extends Trait
class_name GiantSlayer

const damage_multi = 1.1
const hp_threshold = 0.6

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	if damage_info.target.hp_percent() > hp_threshold:
		damage_info.phys_damage(damage_info.phys_damage * damage_multi)
		damage_info.magic_damage(damage_info.magic_damage * damage_multi)

func description():
	return "Deal " + str((damage_multi - 1) * 100) + "% more damage to targets above " + str(hp_threshold * 100) + "% of their HP."
