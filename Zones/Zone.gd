extends Node2D
class_name Zone

export var zone_name = ""
export var level = 1
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Texture) var texture

var zone_floor = 0

func _ready():
	CombatProcessor.connect("exited_combat", self, "_on_exited_combat")

func modifier(_modifier):
	modifiers.append(_modifier)

func level(_level):
	level = _level

func zone_name(_zone_name):
	zone_name = _zone_name

func get_zone_info():
	return "Level " + str(level) + " " + zone_name + " : " + str(zone_floor)

func make_zone_monster():
	var monster_scene = enemies[randi() % (enemies.size())]
	var new_monster = monster_scene.instance() \
		.set_level(level) \
		.add_modifiers(modifiers)
	return new_monster

# Override for cool ass zones
func _on_exited_combat():
	zone_floor += 1
