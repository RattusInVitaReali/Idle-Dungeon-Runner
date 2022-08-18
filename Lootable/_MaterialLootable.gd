extends Lootable
class_name MaterialLootable

const CraftingMaterial = preload("res://Materials/CraftingMaterial.tscn")

export (Resource) var material
export (int) var base_min_quantity = 1
export (int) var base_max_quantity = 1

var min_quantity = base_min_quantity
var max_quantity = base_max_quantity

func get_loot():
	return CraftingMaterial.instance().from_lootable(self)

func set_level(level):
	set_quantity(level)

func set_quantity(level):
	min_quantity = int(ceil(base_min_quantity * sqrt(1 + level) - base_min_quantity))
	max_quantity = int(ceil(base_max_quantity * sqrt(1 + level) - base_max_quantity))

func get_quantity():
	return int(round(Random.rng.randf_range(min_quantity, max_quantity)))
