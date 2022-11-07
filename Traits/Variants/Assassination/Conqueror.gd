extends Trait
class_name Conqueror

const ConquerorEffect = preload("res://Effects/Conqueror/ConquerorEffect.tscn")

func on_skill_used(skill : Skill):
	if entity.has_effect("Conqueror"):
		entity.get_effect("Conqueror").add_stack()
	else:
		entity.process_outgoing_effect(
			ConquerorEffect.instance() \
				.initialize(entity, entity) \
				.duration(3600) \
		)

func description():
	return "Every time you use a skill, gain " + str(0.005 * 100) + "% Power until the end of combat."
