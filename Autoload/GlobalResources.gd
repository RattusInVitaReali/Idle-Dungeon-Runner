extends GlobalSaveable
class_name GlobalResourcesScript

enum GLOBAL_RESOURCES {
	SKILL_LOTUSES
	SKILL_POINTS
}

signal skill_lotuses_changed
signal skill_points_changed

onready var global_resource_icons = {
	GLOBAL_RESOURCES.SKILL_LOTUSES : preload("res://_Resources/lotus.png"),
	GLOBAL_RESOURCES.SKILL_POINTS : preload("res://_Resources/SkillIcon.png")
}

onready var global_resource_vars = {
	GLOBAL_RESOURCES.SKILL_LOTUSES : "SKILL_LOTUSES",
	GLOBAL_RESOURCES.SKILL_POINTS : "SKILL_POINTS"
}

export var SKILL_LOTUSES = 0 setget set_skill_lotuses
export var SKILL_POINTS = 0 setget set_skill_points

func save_path():
	return "user://globals.tscn"

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")

func set_skill_lotuses(new_value):
	SKILL_LOTUSES = new_value
	emit_signal("skill_lotuses_changed")

func set_skill_points(new_value):
	SKILL_POINTS = new_value
	emit_signal("skill_points_changed")

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.GLOBAL_RESOURCE:
		process_slottable(item)
		item.queue_free()

func process_slottable(slottable):
	set(global_resource_vars[slottable.global_resource], get(global_resource_vars[slottable.global_resource]) + slottable.quantity)
