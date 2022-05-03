extends Lootable
class_name ItemPartLootable

export (PackedScene) var part_type
export (Resource) var material

func get_loot():
	return part_type.instance().from_lootable(self)
