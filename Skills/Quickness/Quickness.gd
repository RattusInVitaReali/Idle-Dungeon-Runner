extends Skill
class_name Quickness

var base_amount = 90
var level_amount = 30
var base_duration = 3
var level_duration = 0.1

func calculate_amount():
	return base_amount + level * level_amount

func calculate_duration():
	return base_duration + level * level_duration

func do_skill():
	play_animation("attack")
	var amount = calculate_amount()
	var duration = calculate_duration()
	attacker.remove_effect("Quickness")
	attacker.process_outgoing_effect(
		CombatProcessor.AttributeBonusFlat.instance() \
		.initialize(attacker, target) \
		.attribute("dexterity") \
		.amount(amount) \
		.duration(duration) \
		.icon(skill_icon) \
		.effect_name("Quickness")
	)

func description():
	var text = "Gain " + str(calculate_amount()) + " dexterity for " + str(calculate_duration()) + " seconds."
	return text
