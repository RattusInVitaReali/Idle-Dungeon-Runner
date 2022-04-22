extends Effect

var tick_damage = 0.0

func tick_damage(_tick_damage):
	tick_damage = _tick_damage
	return self

func tick():
	attacker.process_outgoing_damage(
		CombatProcessor.DamageInfo.new(attacker, target) \
		.phys_damage(tick_damage) \
		.bleeding_tick(true)
	)
