extends Resource
class_name QuestResource

const Quest = preload("res://Quests/Quest.tscn")

export (String) var quest_name
export (int) var required_kills
export (Array, Monster.MONSTER_TYPE) var required_types
export (Array, Resource) var reward

func get_quest():
	return Quest.instance().from_resource(self)
