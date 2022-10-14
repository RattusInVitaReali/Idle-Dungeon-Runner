extends Node2D
class_name Specialization

export (String) var specialization_name
export (Array, String) var titles
export (Texture) var background
export (Array, Resource) var traits
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
export (int) var level = 0

func on_outgoing_effect(effect : Effect):
	if active:
		for trait in traits:
			trait.on_outgoing_effect(effect)

func on_incoming_effect(effect : Effect):
	if active:
		for trait in traits:
			trait.on_incoming_effect(effect)

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	if active:
		for trait in traits:
			trait.on_outgoing_damage(damage_info)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	if active:
		for trait in traits:
			trait.on_incoming_damage(damage_info)
