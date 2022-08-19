extends Skill
class_name Quickslash

var base_damage = 5
var level_damage = 2
var base_multi = 0.5
var level_multi = 0.02
var base_dex_multi = 0.5
var level_dex_multi = 0.02

func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func dex_multiplier():
	return base_dex_multi + level * level_dex_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier() + attacker.attributes.dexterity * dex_multiplier()

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = calculate_damage()
	# DAMAGE INFO
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD + "
	text += str(dex_multiplier() * 100) + "% DEX) = " + str(calculate_damage()) + " physical damage to your enemy."
	return text
