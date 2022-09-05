extends Effect
class_name Quick

var amount = 0

func amount(_amount):
	amount = _amount
	return self

func process_strength_multi(sm):
	amount *= sm

func apply_attributes(attributes):
	attributes["dexterity"] += amount

func get_value():
	return str(amount)
