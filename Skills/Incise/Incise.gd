extends Skill
class_name Incise

var base_damage = 10
var level_damage = 3
var base_multi = 1.0
var level_multi = 0.03
var crit_chance_flat = 0.2
var crit_multi_multi = 1.5

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	# DAMAGE INFO
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.crit_chance_flat(crit_chance_flat) \
		.crit_multi_multi(crit_multi_multi)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy."
	text += " This skill has " + str(crit_chance_flat * 100)  + "% increased crit chance, and deals " + str(crit_multi_multi * 100) + "% damage if it crits."
	return text
