extends Skill

var base_damage = 15
var level_damage = 5
var base_multi = 1.2
var level_multi = 0.05

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func do_skill():
	play_animation("attack")
	var damage = calculate_damage()
	# DAMAGE INFO
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy."
	return text
