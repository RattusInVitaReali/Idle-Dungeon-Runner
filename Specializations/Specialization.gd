extends Node2D
class_name Specialization

signal spec_updated

export (String) var specialization_name
export (Array, String) var titles
export (Texture) var background
export (String) var quote
export (Dictionary) var attributes_per_level = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

export (bool) var active = false
export (int) var level = 1
export (Array, String) var active_traits = []

func _ready():
	for trait in get_traits():
		trait.connect("slottable_updated", self, "_on_trait_updated")
		if trait.slottable_name in active_traits:
			trait.active = true

func get_traits():
	return get_children()

func get_title():
	return titles[level - 1]

func try_allocate(trait):
	if trait in get_traits() and trait.level_required == level and GlobalResources.get_gr_quantity(GlobalResources.GR.TRAIT_POINT) > 0:
		level += 1
		active_traits.append(trait.slottable_name)
		trait.active = true
		GlobalResources.spend_gr(GlobalResources.GR.TRAIT_POINT, 1)

func get_level_attributes():
	var atts = {}
	for att in attributes_per_level:
		if attributes_per_level[att] != 0:
			atts[att] = attributes_per_level[att] * (level - 1)
	return atts

func on_calculate_attributes(attributes):
	var atts = get_level_attributes()
	for att in atts:
		attributes[att] += atts[att]
	for trait in get_traits():
		if trait.active:
			trait.on_calculate_attributes(attributes)

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	if active:
		for trait in get_traits():
			if trait.active:
				trait.on_outgoing_damage(damage_info)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	if active:
		for trait in get_traits():
			if trait.active:
				trait.on_incoming_damage(damage_info)

func on_outgoing_effect(effect : Effect):
	if active:
		for trait in get_traits():
			if trait.active:
				trait.on_outgoing_effect(effect)

func on_incoming_effect(effect : Effect):
	if active:
		for trait in get_traits():
			if trait.active:
				trait.on_incoming_effect(effect)

func _on_trait_updated():
	emit_signal("spec_updated")
