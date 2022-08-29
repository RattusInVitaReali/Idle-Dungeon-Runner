extends Node2D
class_name Zone

signal unlocked
signal zone_updated
signal quest_changed

export var zone_name = ""
export var unlock_zone_name = ""
export var unlock_monster_base_name = ""
export var unlock_signal_level = 0
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Array, Resource) var loot = []
export (Array, Resource) var quests = []
export (Texture) var texture

export (int) var level setget set_level
export (int) var save_level
export (int) var min_level
export (int) var max_level
export (int) var max_level_reached
export (int) var zone_floor = 0

export (bool) var active = false

var quest = null
var player : Player = null

export var locked = false

func _ready():
	max_level_reached = max(max_level_reached, min_level)
	set_level(max(save_level, min_level))
	if unlock_zone_name != "" or unlock_monster_base_name != "":
		Progression.connect("progression_monster_died", self, "try_unlock")
	else:
		locked = false
	load_quest()

func set_level(_level):
	if _level <= max_level_reached:
		level = _level
		save_level = level
		emit_signal("zone_updated")

func try_unlock(monster, zone):
	if monster.base_name == unlock_monster_base_name or zone.zone_name == unlock_zone_name:
		if monster.level >= unlock_signal_level:
			unlock()

func unlock():
	locked = false
	emit_signal("unlocked")
	Progression.disconnect("progression_monster_died", self, "try_unlock")

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

func get_monster_instances():
	var monsters = []
	for monster_scene in enemies:
		var new_monster = monster_scene.instance() \
			.set_level(level) \
			.add_modifiers(modifiers) \
			.add_loot(loot)
		monsters.append(new_monster)
	return monsters

func get_lootables():
	return loot

func get_monster_scenes():
	return enemies

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
		if level == max_level_reached:
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

func load_quest():
	if get_child_count() != 0:
		quest = get_child(0)
		quest.load()
		quest.connect("quest_completed", self, "_on_quest_completed")
		emit_signal("quest_changed", quest)
	else:
		new_quest()
