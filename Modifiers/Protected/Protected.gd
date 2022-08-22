extends Modifier
class_name Protected

var base = 5
var level_multi = 2

func bonus_protection(level):
	return base + level * level_multi

func effect(stats, level):
	stats.phys_protection += bonus_protection(level)
	stats.magic_protection += bonus_protection(level)
