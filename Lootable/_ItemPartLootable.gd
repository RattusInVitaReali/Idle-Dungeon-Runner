extends Lootable
class_name ItemPartLootable

export (PackedScene) var part_type
export (Resource) var material

var tier = 0

func set_level(_level):
	.set_level(_level)
	if level > 1:
		tier = max(0, floor(sqrt(level / 2 - 1)) - 1)
	else:
		tier = 0

func get_loot():
	return part_type.instance().from_lootable(self)
