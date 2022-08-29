extends Resource
class_name Lootable

export (float) var chance = 1

export (int) var min_level = 0
export (int) var max_level = 1000

var level = 0

func get_loot():
	return null

func get_loot_if_level():
	if level >= min_level and level <= max_level:
		return get_loot()
	return null

func set_level(_level):
	level = _level

func roll_loot():
	if Random.rng.randf() < chance:
		return get_loot_if_level()
	return null
