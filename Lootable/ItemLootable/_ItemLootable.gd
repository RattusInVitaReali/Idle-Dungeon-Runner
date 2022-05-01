extends Lootable
class_name ItemLootable

export (PackedScene) var item_type
export (Array, Resource) var parts

func get_loot():
	var _parts = []
	for part in parts:
		_parts.append(part.get_loot()) # Make use of ItemPartLootable.get_loot()
	var item = item_type.instance()
	item.create(_parts)
	return item
