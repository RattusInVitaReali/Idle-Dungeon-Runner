extends Modifier

var base = 5
var level_multi = 2

func bonus_phys_damage(level):
	return base + level * level_multi

func effect(stats, level):
	stats.phys_damage += bonus_phys_damage(level)
