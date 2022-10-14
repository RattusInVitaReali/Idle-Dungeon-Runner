extends TextureRect
class_name SpecializationInfo

const SpecializationAttribute = preload("res://UI/Screens/Specializations/SpecializationInfo/SpecializationAttribute/SpecializationAttribute.tscn")

onready var spec_name = $Background/HBoxContainer/VBoxContainer/NameBackground/Name
onready var attributes_container = $Background/HBoxContainer/VBoxContainer/HBoxContainer/AttributesBackground/VBoxContainer/ScrollContainer/AttributesContainer

var spec : Specialization = null

func _ready():
	set_specialization(load( "res://Specializations/Variants/Assassination.tscn").instance())

func set_specialization(_spec):
	spec = _spec
	set_background()
	set_spec_name()
	set_attributes()

func set_background():
	$Background.texture = spec.background

func set_spec_name():
	spec_name.text = spec.specialization_name + ":\n" + spec.titles[spec.level - 1]

func set_attributes():
	for child in attributes_container.get_children():
		child.queue_free()
	for att in spec.attributes_per_level:
		if spec.attributes_per_level[att] != 0:
			var line = SpecializationAttribute.instance()
			attributes_container.add_child(line)
			line.set_attribute(att, spec.attributes_per_level[att] * spec.level)
