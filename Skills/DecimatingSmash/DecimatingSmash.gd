extends Skill

var level_damage = 8
var base_damage = 20
var base_multi = 1.75
var level_multi = 0.07
var base_decimated_strength = 0.2
var level_decimated_strength = 0.02
var decimated_duration = 5

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func calculate_decimated_strength():
	return base_decimated_strength + level * level_decimated_strength

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	var decimated_strength = calculate_decimated_strength()
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.effect(
			CombatProcessor.Decimated.instance() \
			.initialize(attacker, target) \
			.duration(decimated_duration) \
			.strength(decimated_strength)
		)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage())
	text += " physical damage to your enemy, and reduce their armor by " + str(calculate_decimated_strength() * 100)
	text += "% for " + str(decimated_duration) + " seconds."
	return text
