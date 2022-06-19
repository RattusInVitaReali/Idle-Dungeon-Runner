extends Node2D
class_name Zone

signal zone_updated
signal quest_changed

export var zone_name = ""
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Array, Resource) var loot = []
export (Array, Resource) var quests = []
export (Texture) var texture

var level = 1
export (int) var min_level
export (int) var max_level

var zone_floor = 0
var quest = null

func _ready():
	level = min_level
	new_quest()

func modifier(_modifier):
	modifiers.append(_modifier)

func get_zone_info():
	return "Level " + str(level) + " " + zone_name + " : " + str(zone_floor)

func make_zone_monster():
	var monster_scene = enemies[Random.rng.randi() % (enemies.size())]
	var new_monster = monster_scene.instance() \
		.set_level(level) \
		.add_modifiers(modifiers) \
		.add_loot(loot)
	return new_monster

func level_up():
	level = min(level + 1, max_level)

func level_down():
	level = max(level - 1, min_level)

func activate_quest(value):
	if quest != null:
		quest.active = value

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
