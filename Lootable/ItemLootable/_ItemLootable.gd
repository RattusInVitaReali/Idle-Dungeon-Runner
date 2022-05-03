extends Lootable
class_name ItemLootable

export (PackedScene) var item_type
export (Array, Resource) var parts
export (String) var custom_name

func get_loot():
	return item_type.instance().from_lootable(self)
