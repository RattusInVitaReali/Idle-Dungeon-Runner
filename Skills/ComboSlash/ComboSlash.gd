extends Skill
class_name ComboSlash

var base_damage = 15
var level_damage = 5
var base_multi = 1.2
var level_multi = 0.05

var combo_damage_multi = 1.75
var counter = 0

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func multiply_damage(damage):
	if counter == 2: # if third strike, apply multiply
		counter = 0
		damage *= combo_damage_multi
	else:
		counter += 1
	return damage

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = multiply_damage(calculate_damage())
	# DAMAGE INFO
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy. This skill deals " + str(combo_damage_multi * 100) + "% damage on every third cast."
	return text
