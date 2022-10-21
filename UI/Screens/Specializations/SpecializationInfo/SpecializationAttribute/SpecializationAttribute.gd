extends HBoxContainer
class_name SpecializationInspectorAttribute

func set_attribute(att, value):
	$Name.text = att.capitalize()
	$Value.text = str(value)
