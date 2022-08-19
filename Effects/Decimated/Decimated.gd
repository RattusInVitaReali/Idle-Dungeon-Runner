extends Effect
class_name Decimated

var strength = 0.0

func strength(_strength):
	strength = _strength
	return self

func process_strength_multi(sm):
	strength = min(1, strength * sm)

func apply_attributes(attributes):
	attributes["armor"] *= (1 - strength)
