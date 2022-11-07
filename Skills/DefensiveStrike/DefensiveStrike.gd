extends Skill
class_name DefensiveStrike

var base_damage = 10
var level_damage = 3
var base_multi = 1.0
var level_multi = 0.03

var shielded_duration = 3

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
		.phys_damage(damage)
	)
	attacker.remove_effect("Shielded")
	attacker.process_outgoing_effect(
		CombatProcessor.Shielded.instance() \
		.initialize(attacker, attacker) \
		.amount(damage / 3) \
		.duration(shielded_duration)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy, and gain " + str(calculate_damage() / 2) + " shielding."
	return text
