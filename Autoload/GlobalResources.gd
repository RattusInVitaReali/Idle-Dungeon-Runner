extends Node

signal skill_lotuses_changed
signal skill_points_changed

const save_path = "user://globals.tscn"

export var SKILL_LOTUSES = 0 setget set_skill_lotuses
export var SKILL_POINTS = 0 setget set_skill_points

func _ready():
	Saver.save(self)
	self.load()

func set_skill_lotuses(new_value):
	SKILL_LOTUSES = new_value
	emit_signal("skill_lotuses_changed")

func set_skill_points(new_value):
	SKILL_POINTS = new_value
	emit_signal("skill_points_changed")

func load():
	if save_path != "" and ResourceLoader.exists(save_path):
		var instance = load(save_path).instance()
		for prop in instance.get_property_list():
			if prop.usage == 8192: # EXPORT VAR
				set(prop.name, instance.get(prop.name))

func save_and_exit():
	Saver.save_scene(self, save_path)
