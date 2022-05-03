extends Control

const EffectIcon = preload("res://UI/CombatScreen/EffectIcon/EffectIcon.tscn")

onready var player_hp_bar = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar
onready var player_hp_value = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/HPValue
onready var player_hp_tween = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/Tween
onready var effects = $VBoxContainer/Effects

var player

func _ready():
	CombatProcessor.connect("player_spawned", self, "update_info")

func update_info(_player):
	player = _player
	player.connect("hp_updated", self, "update_player_hp")
	player.connect("effect_applied", self, "apply_effect")
	update_player_hp()
	update_skills()

func update_player_hp():
	player_hp_bar.max_value = player.stats.max_hp
	player_hp_tween.interpolate_property(
		player_hp_bar, 
		"value", 
		player_hp_bar.value, 
		player.stats.hp,
		0.2, Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	player_hp_tween.start()
	player_hp_value.text = str(int(player.stats.hp)) + " HP"

func update_skills():
	for skill_icon in get_tree().get_nodes_in_group("skills"):
		skill_icon.update_skill(null)
	for skill in player.get_skills():
		for skill_icon in get_tree().get_nodes_in_group("skills"):
			if skill_icon.skill == null:
				skill_icon.update_skill(skill)
				break

func apply_effect(effect):
	var new_effect = EffectIcon.instance()
	new_effect.initialize(effect)
	effects.add_child(new_effect)
