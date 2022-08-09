extends Resource
class_name Lootable

export (float) var chance = 1

func get_loot():
	return null

func set_level(level):
	pass

func roll_loot():
	if Random.rng.randf() < chance:
		return get_loot()
	return null
