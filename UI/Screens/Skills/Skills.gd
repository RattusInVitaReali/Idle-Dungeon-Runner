extends Screen
class_name SkillsUI

onready var skills = $VBoxContainer/Screen/VBoxContainer/SkillsInventory

func _ready():
	skills.connect("inspector", self, "_on_inspector")

func set_container(container):
	skills.set_items_container(container)

func _on_player_spawned(_player):
	._on_player_spawned(_player)
	set_container(player.get_skills_container())
