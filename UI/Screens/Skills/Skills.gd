extends Screen
class_name SkillsUI

onready var skills = $VBoxContainer/Screen/VBoxContainer/SkillsInventory

func _ready():
	skills.connect("inspector", self, "_on_inspector")

func add_skill(skill):
	skills.add_slottable(skill)
