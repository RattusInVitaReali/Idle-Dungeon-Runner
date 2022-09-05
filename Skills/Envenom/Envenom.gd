extends Skill
class_name Envenom

var level_damage = 4
var base_damage = 12
var base_multi = 1.1
var level_multi = 0.04
var poison_duration = 3
var tick_duration = 0.5

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func calculate_poison_damage(damage):
	return damage / 5

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	var poison_damage = calculate_poison_damage(damage)
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.effect(
			CombatProcessor.Poisoned.instance() \
			.initialize(attacker, target) \
			.duration(poison_duration) \
			.tick_duration(tick_duration) \
			.tick_damage(poison_damage)
		)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy, "
	text += "and poison the enemy dealing (" + str(base_damage() / 5) + " + " + str(multiplier() * 100 / 5) + "% PD) = " + str(calculate_poison_damage(calculate_damage())) + " magic "
	text += " damage every " + str(tick_duration) + " seconds for " + str(poison_duration) + " seconds."
	return text
