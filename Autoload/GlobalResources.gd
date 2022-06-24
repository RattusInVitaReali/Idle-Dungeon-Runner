extends Node

signal skill_lotuses_changed
signal skill_points_changed

var SKILL_LOTUSES = 1000 setget set_skill_lotuses
var SKILL_POINTS = 1000 setget set_skill_points

func set_skill_lotuses(new_value):
	SKILL_LOTUSES = new_value
	emit_signal("skill_lotuses_changed")

func set_skill_points(new_value):
	SKILL_POINTS = new_value
	emit_signal("skill_points_changed")
