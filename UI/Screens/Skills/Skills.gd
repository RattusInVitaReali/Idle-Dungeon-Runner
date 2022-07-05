extends Screen
class_name SkillsUI

onready var skills = $VBoxContainer/Screen/VBoxContainer/SkillsInventory

func _ready():
	skills.connect("inspector", self, "_on_inspector")

func set_container(container):
	skills.set_items_container(container)
