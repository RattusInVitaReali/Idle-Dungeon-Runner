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

func _on_Refund_pressed():
	get_confirm_response("Are you sure you want to restore ALL skill points?")
	if yield(self, "confirm_response"):
		refund_skill_points()

func refund_skill_points():
	for skill in skills.get_items_container().get_children():
		skill.refund()
