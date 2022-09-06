extends Effect
class_name Shielded

var amount = 0 setget amount

func get_value():
	return str(stepify(amount, 1))

func amount(_amount):
	amount = _amount
	if amount == 0:
		expire()
	emit_signal("effect_updated")
	return self

func process_strength_multi(sm): 
	amount *= sm

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	var phys_reduction = min(amount, damage_info.phys_damage)
	damage_info.phys_damage -= phys_reduction
	self.amount -= phys_reduction
	var magic_reduction = min(amount, damage_info.magic_damage)
	damage_info.magic_damage -= magic_reduction
	self.amount -= magic_reduction
