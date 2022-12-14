extends Slottable
class_name Trait

const BorderDefault = preload("res://RESOURCES/SkillBorders/Border3.png")
const BorderActive = preload("res://RESOURCES/SkillBorders/Border4.png")

export (int) var level_required
export (bool) var active setget set_active

var entity

func _ready():
	CombatProcessor.connect("exited_combat", self, "_on_exited_combat")

func copy(trait : Slottable):
	.copy(trait)
	set_active(trait.active)

func set_active(_active):
	if _active != active:
		active = _active
		emit_signal("slottable_updated")

func get_border_texture():
	if active:
		return BorderActive
	return BorderDefault

func on_calculate_attributes(attributes):
	pass

func on_outgoing_effect(effect : Effect):
	pass

func on_incoming_effect(effect : Effect):
	pass

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_skill_used(skill : Skill):
	pass

func _on_exited_combat():
	pass

func description():
	return ""
