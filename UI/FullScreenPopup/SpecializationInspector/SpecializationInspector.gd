extends FullScreenPopup
class_name SpecializationInspector

const SpecializationInspectorAttribute = preload("res://UI/FullScreenPopup/SpecializationInspector/SpecializationInspectorAttribute/SpecializationInspectorAttribute.tscn")
const TraitSlot = preload("res://UI/Slot/TraitSlot/TraitSlot.tscn")

signal inspector

onready var spec_name = $Panel/VBoxContainer/Name/SpecializationName
onready var rank = $Panel/VBoxContainer/Rank/Rank/Rank
onready var quote = $Panel/VBoxContainer/Attributes/HBoxContainer/Quote
onready var attributes_container = $Panel/VBoxContainer/Attributes/HBoxContainer/AttributesContainer
onready var trait_container = $Panel/VBoxContainer/SkillTree/ScrollContainer/TraitContainer

var spec : Specialization

func _ready():
	var test = load("res://Specializations/Variants/Assassination.tscn").instance()
	set_spec(test)

func set_spec(_spec):
	spec = _spec
	update_all()
	spec.connect("spec_updated", self, "update_all")

func update_all():
	set_spec_name()
	set_rank()
	set_quote()
	set_attributes()
	set_traits()

func set_spec_name():
	spec_name.text = spec.name

func set_rank():
	rank.text = spec.get_title()

func set_quote():
	quote.text= "\"" + spec.quote + "\""

func set_attributes():
	for child in attributes_container.get_children():
		child.queue_free()
	var atts = spec.get_level_attributes()
	for att in atts:
		var line = SpecializationInspectorAttribute.instance()
		attributes_container.add_child(line)
		line.set_attribute(att, atts[att])

func set_traits():
	for trait in trait_container.get_children():
		trait.queue_free()
	var counter = 0
	for trait in spec.get_traits():
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
	slot.set_slottable(trait)
	slot.spec = spec
	slot.connect("inspector", self, "_on_inspector")

func _on_inspector(slot):
	emit_signal("inspector", slot)
