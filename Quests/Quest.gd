extends Node2D
class_name Quest

signal loot
signal quest_updated
signal quest_completed

var quest_name
var required_kills = 0
var required_types
var reward

var quest_resource = null

var kill_count = 0
var total_levels = 0

var active = false

func _ready():
	connect("loot", LootManager, "_on_loot")
	CombatProcessor.connect("monster_died", self, "_on_monster_died")

func from_resource(resource):
	quest_resource = resource
	quest_name = resource.quest_name
	required_kills = resource.required_kills
	required_types = resource.required_types.duplicate()
	reward = resource.reward.duplicate()
	return self

func _on_monster_died(monster, zone):
	if active:
		for type in required_types:
			if type in monster.monster_types:
				total_levels += monster.level
				add_kills(1)
				break

func add_kills(count):
	if count == 0:
		return
	kill_count = min(kill_count + 1, required_kills)
	emit_signal("quest_updated")
	if kill_count == required_kills:
		complete()

func complete():
	emit_signal("quest_completed")
	emit_signal("loot", reward, total_levels / kill_count)
	CombatProcessor.disconnect("monster_died", self, "_on_monster_died")
	queue_free()

func quest_info():
	return quest_name + " : " + str(kill_count) + " / " + str(required_kills)

func get_lootables():
	return reward
