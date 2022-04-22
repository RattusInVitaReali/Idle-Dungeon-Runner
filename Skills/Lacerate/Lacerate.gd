extends Skill

var level_damage = 5
var base_damage = 15
var bleed_duration = 2
var tick_duration = 0.5

func base_damage():
	return base_damage + level_damage * level

func level_multi():
	return 1.2 + level * 0.05

func calculate_damage():
	return base_damage() + attacker.stats.phys_damage * level_multi()

func calculate_bleed_damage(damage):
	return damage / 5

func do_skill():
	play_animation("attack")
	var damage = calculate_damage()
	var bleed_damage = calculate_bleed_damage(damage)
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(damage) \
		.effect(
			CombatProcessor.Bleeding.instance() \
			.initialize(attacker, target) \
			.duration(bleed_duration) \
			.tick_duration(tick_duration) \
			.tick_damage(bleed_damage)
		)
	)
