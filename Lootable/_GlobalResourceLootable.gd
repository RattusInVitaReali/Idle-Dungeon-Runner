extends Lootable
class_name GlobalResourceLootable

const GlobalResourceSlottable = preload("res://Slottable/GlobalResourceSlottable/GlobalResourceSlottable.tscn")

export (GlobalResourcesScript.GLOBAL_RESOURCES) var global_resource
export (int) var base_min_quantity = 1
export (int) var base_max_quantity = 1

var min_quantity = base_min_quantity
var max_quantity = base_max_quantity

func get_loot():
	return GlobalResourceSlottable.instance().from_lootable(self).set_quantity(get_quantity())

func set_level(_level):
	.set_level(_level)
	min_quantity = int(base_min_quantity * (1 + level / 2))
	max_quantity = int(base_max_quantity * (1 + level / 2))

func get_quantity():
	return min_quantity + Random.rng.randi() % (max_quantity - min_quantity + 1)
