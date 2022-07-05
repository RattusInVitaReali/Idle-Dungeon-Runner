extends GameScreen
class_name SkillsScreen

var player : Player

func _ready():
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")

func _on_player_spawned(_player):
	player = _player
	$Skills.set_container(player.get_skills_container())
