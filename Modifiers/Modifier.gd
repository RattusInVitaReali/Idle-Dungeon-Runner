extends Resource
class_name Modifier

export var mod_name = "Modifier"
export var prefix = false
export var suffix = false

func apply_effect(stats, level):
	effect(stats, level)

func effect(stats, level):
	pass
