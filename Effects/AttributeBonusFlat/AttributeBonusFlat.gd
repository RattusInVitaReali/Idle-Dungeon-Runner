extends Effect
class_name AttributeBonusFlat

var amount = 0
var attribute : String

func amount(_amount):
	amount = _amount
	if amount > 0:
		icon(IconPositive)
	else:
		icon(IconNegative)
	return self
	
func attribute(_attribute): # set the type of attribute to which the effect is applied
	attribute = _attribute
	return self
	
func process_strength_multi(sm): 
	amount *= sm

func apply_attributes(attributes):
	attributes[attribute] += amount
