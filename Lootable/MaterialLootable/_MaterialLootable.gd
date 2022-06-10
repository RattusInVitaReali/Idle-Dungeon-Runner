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

func set_quantity(level):
	min_quantity = int(base_min_quantity * (1 + level / 2))
	max_quantity = int(base_max_quantity * (1 + level / 2))
