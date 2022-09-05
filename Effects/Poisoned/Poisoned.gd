extends Effect
class_name Poisoned

var tick_damage = 0.0

func tick_damage(_tick_damage):
	tick_damage = _tick_damage
	return self

func process_strength_multi(sm):
	tick_damage *= sm

func tick():
	var damage_info = \
		CombatProcessor.DamageInfo.new(attacker, target) \
		.magic_damage(tick_damage) \
		.can_crit(false)
	if is_crit:
		damage_info.apply_crit(attacker.stats.crit_multi)
	attacker.process_outgoing_damage(damage_info)

func get_value():
	return str(round(tick_damage))
