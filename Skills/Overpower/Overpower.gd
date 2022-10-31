extends Skill
class_name Overpower

var base_damage = 18
var level_damage = 6
var base_multi = 1.3
var level_multi = 0.06

var overpower_duration = 3
var base_overpower = 25
var level_overpower = 5

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func calculate_overpower():
	return base_overpower + level_overpower * level

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	var overpower_amount = calculate_overpower()
	# DAMAGE INFO
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.effect(
			CombatProcessor.AttributeBonusFlat.instance() \
			.initialize(attacker, target) \
			.attribute("power") \
			.amount(-overpower_amount) \
			.duration(overpower_duration) \
			.icon(skill_icon)
		)
	)
	attacker.process_outgoing_effect(
		CombatProcessor.AttributeBonusFlat.instance() \
		.initialize(attacker, attacker) \
		.attribute("power") \
		.amount(overpower_amount) \
		.duration(overpower_duration) \
		.icon(skill_icon)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy and steal " + str(calculate_overpower()) + " power from them for " + str(overpower_duration) + " seconds."
	return text
