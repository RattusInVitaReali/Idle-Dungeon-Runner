extends Skill
class_name Envenom

var base_damage = 15
var level_damage = 5
var base_multi = 1.2
var level_multi = 0.05
var poison_duration = 3
var level_duration = 0.15
var tick_duration = 0.25

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func calculate_poison_damage(damage):
	return damage / 10

func calculate_poison_duration():
	return poison_duration + level_duration * level

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	var poison_damage = calculate_poison_damage(damage)
	var duration = calculate_poison_duration()
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.effect(
			CombatProcessor.Poisoned.instance() \
			.initialize(attacker, target) \
			.duration(duration) \
			.tick_duration(tick_duration) \
			.tick_damage(poison_damage)
		)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy, and poison the enemy dealing (" + str(base_damage() / 5) + " + " + str(multiplier() * 100 / 5) + "% PD) = " + str(calculate_poison_damage(calculate_damage())) + " magic damage every " + str(tick_duration) + " seconds for " + str(calculate_poison_duration()) + " seconds."
	return text
