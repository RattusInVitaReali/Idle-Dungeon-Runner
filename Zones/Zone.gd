extends Node2D
class_name Zone

signal zone_updated

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
	CombatProcessor.connect("exited_combat", self, "_on_exited_combat")
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
	var monster_scene = enemies[randi() % (enemies.size())]
	var new_monster = monster_scene.instance() \
		.set_level(level) \
		.add_modifiers(modifiers) \
		.add_loot(loot)
	return new_monster

# Override for cool ass zones
func _on_exited_combat():
	zone_floor += 1
	emit_signal("zone_updated")

func _on_quest_completed():
	new_quest()

func new_quest():
	print("New quest")
	if !quests.empty():
		quest = quests[randi() % quests.size()].get_quest()
		add_child(quest)
		quest.connect("quest_completed", self, "_on_quest_completed")
		CombatProcessor.emit_signal("quest_changed", quest)
