extends HBoxContainer
class_name SpecializationAttribute

func set_attribute(att, value):
	$Name.text = att.capitalize()
	$Value.text = str(value)
