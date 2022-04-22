extends Modifier

var base = 15
var level_multi = 7

func bonus_hp(level):
	return base + level * level_multi

func effect(stats, level):
	stats.max_hp += bonus_hp(level)
	stats.hp += bonus_hp(level)
