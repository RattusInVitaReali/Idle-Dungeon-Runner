extends Node
class_name GlobalResourcesScript

enum GLOBAL_RESOURCES {
	SKILL_LOTUSES
	SKILL_POINTS
}

const save_path = "user://globals.tscn"

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

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")
	Saver.save_on_exit(self)
	self.load()

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

func load():
	if save_path != "" and ResourceLoader.exists(save_path):
		var instance = load(save_path).instance()
		for prop in instance.get_property_list():
			if prop.usage == 8199: # EXPORT VAR
				set(prop.name, instance.get(prop.name))
		instance.queue_free()

func save_and_exit():
	Saver.save_scene(self, save_path)
