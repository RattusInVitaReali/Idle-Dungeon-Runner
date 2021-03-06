extends Node2D
class_name Zone

signal unlocked
signal zone_updated
signal quest_changed

export var zone_name = ""
export var unlock_signal = ""
export var unlock_signal_level = 0
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Array, Resource) var loot = []
export (Array, Resource) var quests = []
export (Texture) var texture

var level setget set_level
export (int) var min_level
export (int) var max_level

var max_level_reached

var zone_floor = 0
var quest : Quest = null
var player : Player = null

var locked = false

func _ready():
	if unlock_signal != "":
		locked = true
		Progression.connect(unlock_signal, self, "unlock")
	level = min_level
	max_level_reached = level
	new_quest()

func set_level(_level):
	if _level <= max_level_reached:
		level = _level
		emit_signal("zone_updated")

func unlock(var _level):
	if _level >= unlock_signal_level:
		locked = false
		emit_signal("unlocked")
		Progression.disconnect(unlock_signal, self, "unlock")

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
	new_monster.connect("despawned", self, "_on_monster_despawned")
	return new_monster

func level_up():
	self.level = min(level + 1, max_level)

func level_down():
	self.level = max(level - 1, min_level)

func activate_quest(value):
	if quest != null:
		quest.active = value

func _on_player_died():
	CombatProcessor.breakthrough = false
	level_down()

# Override for cool ass zones
func _on_monster_despawned():
	zone_floor += 1
	if CombatProcessor.breakthrough:
		max_level_reached = min(max_level_reached + 1, max_level)
		level_up()
	emit_signal("zone_updated")

func _on_quest_completed():
	new_quest()

func new_quest():
	if !quests.empty():
		quest = quests[Random.rng.randi() % quests.size()].get_quest()
		add_child(quest)
		quest.connect("quest_completed", self, "_on_quest_completed")
		emit_signal("quest_changed", quest)
