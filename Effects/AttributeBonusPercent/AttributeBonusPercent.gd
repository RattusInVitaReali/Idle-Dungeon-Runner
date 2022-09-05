extends Effect
class_name AttributeBonusPercent

var strength = 0
var attribute : String

func get_value():
	return str(strength * 100) + "%"

func strength(_strength):
	strength = _strength
	if strength > 0:
		icon(IconPositive)
	else:
		icon(IconNegative)
	return self

func attribute(_attribute): # set the type of attribute to which the effect is applied
	attribute = _attribute
	return self

func process_strength_multi(sm): 
	strength *= sm

func apply_attributes(attributes):
	attributes[attribute] *= (1 + strength)
