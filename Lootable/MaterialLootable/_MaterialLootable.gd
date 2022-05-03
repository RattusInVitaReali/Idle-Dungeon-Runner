extends Lootable
class_name MaterialLootable

const CraftingMaterial = preload("res://Materials/CraftingMaterial.tscn")

export (Resource) var material
export (int) var min_quantity = 1
export (int) var max_quantity = 1

func get_loot():
	return CraftingMaterial.instance().from_lootable(self)
