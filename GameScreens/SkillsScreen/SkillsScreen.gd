extends GameScreen

var player

func _ready():
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")

func _on_player_spawned(_player):
	player = _player
	set_skills(player.get_skills())

func set_skills(skills):
	for skill in skills:
		$Skills.add_skill(skill)
