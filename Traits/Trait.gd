extends Resource
class_name Trait

export (String) var trait_name
export (String) var requirement
export (Texture) var trait_icon

func on_outgoing_effect(effect : Effect):
	pass

func on_incoming_effect(effect : Effect):
	pass

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	pass
