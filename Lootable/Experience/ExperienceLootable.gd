extends Lootable
class_name ExperienceLootable

const ExperienceSlottable = preload("res://Slottable/ExperienceSlottable/ExperienceSlottable.tscn")

var experience = 0

func set_level(level):
	if level <= 20:
		experience = level * 5
	else:
		experience = int(12.5 * (pow(level + 1, 2.5) - pow(level, 2.5)) / pow(level, 1.1)) + 5

func get_loot():
	return ExperienceSlottable.instance().quantity(experience)
