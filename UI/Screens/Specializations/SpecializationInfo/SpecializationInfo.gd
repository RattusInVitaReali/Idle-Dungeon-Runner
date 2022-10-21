extends NinePatchRect
class_name SpecializationInfo

const SpecializationAttribute = preload("res://UI/Screens/Specializations/SpecializationInfo/SpecializationAttribute/SpecializationAttribute.tscn")

signal inspector

onready var spec_name = $Background/HBoxContainer/VBoxContainer/NameBackground/Name
onready var attributes_container = $Background/HBoxContainer/VBoxContainer/HBoxContainer/AttributesBackground/VBoxContainer/ScrollContainer/AttributesContainer

var spec : Specialization = null

func _ready():
	set_specialization(load( "res://Specializations/Variants/Assassination.tscn").instance())

func set_specialization(_spec):
	spec = _spec
	update_all()
	spec.connect("spec_updated", self, "update_all")

func update_all():
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
	var atts = spec.get_level_attributes()
	for att in atts:
		var line = SpecializationAttribute.instance()
		attributes_container.add_child(line)
		line.set_attribute(att, atts[att])

func _on_SkillTree_pressed():
	emit_signal("inspector", spec)
