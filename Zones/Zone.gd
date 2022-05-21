extends Node2D
class_name Zone

signal zone_updated
signal quest_changed

export var zone_name = ""
export var level = 1
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Array, Resource) var loot = []
export (Array, Resource) var quests = []
export (Texture) var texture

var zone_floor = 0
var quest = null

func _ready():
	new_quest()

func modifier(_modifier):
	modifiers.append(_modifier)

func level(_level):
	level = _level

func zone_name(_zone_name):
	zone_name = _zone_name

func get_zone_info():
	return "Level " + str(level) + " " + zone_name + " : " + str(zone_floor)

func make_zone_monster():
	var monster_scene = enemies[Random.rng.randi() % (enemies.size())]
	var new_monster = monster_scene.instance() \
		.set_level(level) \
		.add_modifiers(modifiers) \
		.add_loot(loot)
	return new_monster

func increment_level():
	level += 1

func decrement_level():
	level -= 1

# Override for cool ass zones
func _on_monster_despawned():
	zone_floor += 1
	emit_signal("zone_updated")

func _on_quest_completed():
	new_quest()

func new_quest():
	if !quests.empty():
		quest = quests[Random.rng.randi() % quests.size()].get_quest()
		add_child(quest)
		quest.connect("quest_completed", self, "_on_quest_completed")
		emit_signal("quest_changed", quest)
