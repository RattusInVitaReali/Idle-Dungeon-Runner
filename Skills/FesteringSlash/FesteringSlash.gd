extends Skill
class_name FesteringSlash

var base_damage = 12
var level_damage = 4
var base_multi = 1.0
var level_multi = 0.04

var bleeding_or_poisoned_damage_multi = 1.75
var bleeding_and_posioned_damage_multi = 2.5


func base_damage():
	return base_damage + level_damage * level

func multiplier():
	return base_multi + level * level_multi

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * multiplier()

func multiply_damage(damage):
	if target.has_effect("Bleeding") and target.has_effect("Poisoned"):
		damage *= bleeding_and_posioned_damage_multi
	elif target.has_effect("Bleeding") or target.has_effect("Poisoned"):
		damage *= bleeding_or_poisoned_damage_multi
	return damage

func do_skill():
	play_animation("melee")
	play_animation("attack")
	var damage = multiply_damage(calculate_damage())
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage)
	)

func description():
	var text = "Deal (" + str(base_damage()) + " + " + str(multiplier() * 100) + "% PD) = " + str(calculate_damage()) + " physical damage to your enemy."
	text += " This skill deals " + str(bleeding_or_poisoned_damage_multi * 100) + "% damage if the target is bleeding or poisoned, or "
	text += str(bleeding_and_posioned_damage_multi) + "% damage if the target is both bleeding and poisoned."
	return text
