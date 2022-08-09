extends Lootable
class_name ItemPartLootable

export (PackedScene) var part_type
export (Resource) var material

var tier = 0

func set_level(level):
	tier = floor(level / 5)

func get_loot():
	return part_type.instance().from_lootable(self)
