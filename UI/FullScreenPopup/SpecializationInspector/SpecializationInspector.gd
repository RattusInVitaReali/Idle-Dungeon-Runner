extends FullScreenPopup
class_name SpecializationInspector

const TraitSlot = preload("res://UI/Screens/Specializations/TraitSlot/TraitSlot.tscn")

onready var trait_container = $Panel/VBoxContainer/SkillTree/ScrollContainer/TraitContainer
onready var spec_name = $Panel/VBoxContainer/Title/SpecializationName
onready var rank = $Panel/VBoxContainer/NinePatchRect/HBoxContainer/Rank/Rank

var spec : Specialization

func _ready():
	var test = load( "res://Specializations/Variants/Assassination.tscn").instance()
	set_spec(test)

func set_spec(_spec):
	spec = _spec
	set_spec_name()
	set_rank()
	set_traits()

func set_spec_name():
	spec_name.text = spec.name

func set_rank():
	rank.text = spec.get_title()

func set_traits():
	var counter = 0
	for trait in spec.traits:
		if counter == 3:
			var margin = Label.new()
			margin.self_modulate = Color(0, 0, 0, 0)
			trait_container.add_child(margin)
			add_trait(trait)
			margin = Label.new()
			margin.self_modulate = Color(0, 0, 0, 0)
			trait_container.add_child(margin)
			counter = 0
		else:
			add_trait(trait)
			counter += 1

func add_trait(trait):
	var slot = TraitSlot.instance()
	trait_container.add_child(slot)
	slot.set_trait(trait)
