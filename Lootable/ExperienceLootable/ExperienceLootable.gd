extends Lootable
class_name ExperienceLootable

const ExperienceSlottable = preload("res://Slottable/ExperienceSlottable/ExperienceSlottable.tscn")

signal get_experience

var experience = 0

func set_level(level):
	if level <= 20:
		experience = level * 5
	else:
		experience = int(12.5 * (pow(level + 1, 2.5) - pow(level, 2.5)) / pow(level, 1.1)) + 5

func get_loot():
	if not is_connected("get_experience", LootManager, "_on_get_experience"):
		connect("get_experience", LootManager, "_on_get_experience")
	emit_signal("get_experience", experience)
	return ExperienceSlottable.instance().quantity(experience)
