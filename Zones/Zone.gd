extends Node2D
class_name Zone

const folder_name = "user://zones"

signal unlocked
signal zone_updated

export var zone_name = ""
export var unlock_zone_name = ""
export var unlock_monster_base_name = ""
export var unlock_signal_level = 0
export (Array, Resource) var modifiers = []
export (Array, PackedScene) var enemies = []
export (Array, Resource) var loot = []
export (Array, Resource) var quests = []
export (Texture) var texture
export (AudioStream) var music

export (int) var min_level
export (int) var max_level

export (int) var level setget set_level
export (int) var save_level
export (int) var max_level_reached
export (int) var zone_floor = 0
export (bool) var can_idle = true
export (bool) var idle_here = false
export (bool) var locked = false

const save_properties = [
	"level",
	"save_level",
	"max_level_reached",
	"zone_floor",
	"can_idle",
	"idle_here",
	"locked"
]

var quest = null
var player : Player = null
var active = false

func _ready():
	Saver.save_on_exit(self)
	self.load()
	max_level_reached = max(max_level_reached, min_level)
	set_level(max(save_level, min_level))
	if (unlock_zone_name != "" or unlock_monster_base_name != "") and locked:
		Progression.connect("progression_monster_died", self, "try_unlock")
	else:
		locked = false

func can_idle_here():
	return can_idle and zone_floor > 1

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

func activate_quest(value = true):
	if quest != null:
		quest.active = value
	if value:
		CombatProcessor.change_quest(quest)

func _on_player_despawned():
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

func activate(value):
	active = value
	activate_quest(value)

func new_quest():
	if !quests.empty():
		var new_quest = quests[Random.rng.randi() % quests.size()].get_quest()
		add_quest(new_quest)

func add_quest(_quest):
	quest = _quest
	add_child(quest)
	quest.connect("quest_completed", self, "_on_quest_completed")
	if active:
		activate_quest()

func copy_quest(from):
	if from.quest_resource != null:
		var new_quest = from.quest_resource.get_quest()
		new_quest.kill_count = from.quest_kills
		new_quest.total_levels = from.quest_levels
		add_quest(new_quest)

func save_path():
	return folder_name + "/" + zone_name.to_lower().replace(" ", "_") + ".tscn"

func load():
	if ResourceLoader.exists(save_path()):
		var saved_scene = load(save_path())
		var instance = saved_scene.instance()
		for prop in save_properties:
			set(prop, instance.get(prop))
		if instance.quest_resource != null:
			copy_quest(instance)
		instance.queue_free()
	else:
		new_quest()

export (Resource) var quest_resource
export (int) var quest_kills
export (int) var quest_levels

func save_and_exit():
	if quest != null:
		quest_resource = quest.quest_resource
		quest_kills = quest.kill_count
		quest_levels = quest.total_levels
	var dir = Directory.new()
	if !dir.dir_exists(folder_name):
		dir.make_dir(folder_name)
	Saver.save_scene(self, save_path())
