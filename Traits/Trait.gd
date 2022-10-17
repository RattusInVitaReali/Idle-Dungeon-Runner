extends Resource
class_name Trait

export (String) var trait_name
export (int) var level_required
export (Texture) var trait_icon
export (bool) var active

func on_calculate_attributes(attributes):
	pass

func on_outgoing_effect(effect : Effect):
	pass

func on_incoming_effect(effect : Effect):
	pass

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func description():
	return ""
