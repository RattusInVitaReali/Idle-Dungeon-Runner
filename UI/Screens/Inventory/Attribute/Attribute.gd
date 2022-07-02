extends VBoxContainer
class_name Attribute

onready var stat_name = $HBoxContainer/Name
onready var value = $HBoxContainer/Value

func init(_name, _value):
	stat_name.text = _name
	value.text = _value
