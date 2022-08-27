extends Node
class_name GlobalSaveable

var save_path = ""

func _ready():
	save_path = save_path()
	Saver.save_on_exit(self)
	self.load()

func save_path():
	return ""

func load():
	if save_path != "" and ResourceLoader.exists(save_path):
		var instance = load(save_path).instance()
		for prop in instance.get_property_list():
			if prop.usage == 8199: # EXPORT VAR
				if prop.type in [18, 19]:
					set(prop.name, instance.get(prop.name).duplicate())
				else:
					set(prop.name, instance.get(prop.name))
		instance.queue_free()

func save_and_exit():
	Saver.save_scene(self, save_path)
