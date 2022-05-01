extends Lootable
class_name ItemPartLootable

export (PackedScene) var part_type
export (Resource) var material

func get_loot():
	var mat = CraftingManager.new_material(material)
	return CraftingManager.new_part(part_type, mat)
