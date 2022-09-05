extends Skill
class_name ImbuedStrike

var base_damage = 18
var level_damage = 6
var base_multi = 1.3
var level_multi = 0.06

var magic_percentage = 0.6

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
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage * (1 - magic_percentage)) \
		.magic_damage(damage * magic_percentage)
	)

func description():
	var text = "Deal (" + str(base_damage() * (1 - magic_percentage)) + " + " + str(multiplier() * 100 * (1 - magic_percentage)) + "% PD) = " + str(calculate_damage() * (1 - magic_percentage)) + " physical damage and (" + str(base_damage() * magic_percentage) + " + " + str(multiplier() * 100 * magic_percentage) + "% PD) = " + str(calculate_damage() * magic_percentage) + " magic damage to your enemy."
	return text
