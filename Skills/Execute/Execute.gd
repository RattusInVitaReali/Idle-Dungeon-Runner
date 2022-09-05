extends Skill
class_name Execute

var base_damage = 20
var level_damage = 8
var base_multi = 1.75
var level_multi = 0.07

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func multiply_damage(damage):
	return damage * (2 - float(target.stats.hp) / target.stats.max_hp)

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
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy."
	text += " Deals up to 200% damage based on the target's missing hp."
	return text
