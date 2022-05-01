extends Lootable
class_name MaterialLootable

export (Resource) var material
export (int) var min_quantity = 1
export (int) var max_quantity = 1

func get_loot():
	var quantity = min_quantity + randi() % (max_quantity - min_quantity + 1)
	return CraftingManager.new_material(material, quantity)
