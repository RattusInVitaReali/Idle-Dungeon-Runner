extends Control
class_name CombatBottom

const EffectIcon = preload("res://UI/Screens/Combat/EffectIcon/EffectIcon.tscn")

onready var player_hp_bar = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar
onready var player_hp_value = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/HPValue
onready var player_hp_tween = $VBoxContainer/Background/VBoxContainer/Stats/Bars/HPBar/Tween
onready var exp_bar = $VBoxContainer/Background/VBoxContainer/Stats/Bars/ExpBar
onready var exp_value = $VBoxContainer/Background/VBoxContainer/Stats/Bars/ExpBar/ExpValue
onready var exp_tween = $VBoxContainer/Background/VBoxContainer/Stats/Bars/ExpBar/Tween
onready var level_label = $VBoxContainer/Background/VBoxContainer/Stats/Level/Control/TextureRect/LevelLabel
onready var effects = $VBoxContainer/Effects

var player : Player

func update_info(_player):
	player = _player
	player.connect("hp_updated", self, "update_player_hp")
	player.connect("effect_applied", self, "apply_effect")
	update_player_hp()
	update_skills()
	update_player_level()
	update_player_exp()
	connect_skills()

func update_player_hp():
	player_hp_bar.max_value = player.stats.max_hp
	player_hp_tween.interpolate_property(
		player_hp_bar, 
		"value", 
		player_hp_bar.value, 
		player.stats["hp"],
		0.2,
		Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	player_hp_tween.start()
	player_hp_value.text = str(int(player.stats["hp"])) + " HP"

func update_skills():
	var skills = []
	var i = 0;
	for skill in player.get_skills():
		if skill.equipped and !skill.locked:
			skills.append(skill)
			i += 1
	while i < 6:
		skills.append(null)
		i += 1
	i = 0
	for skill_icon in get_tree().get_nodes_in_group("skills"):
		skill_icon.set_skill(skills[i])
		i += 1

func update_player_level():
	level_label.text = str(player.level)

func update_player_exp():
	exp_bar.max_value = player.next_level_exp_required()
	exp_tween.interpolate_property(
		exp_bar,
		"value",
		exp_bar.value,
		player.current_level_exp(),
		0.2,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	exp_tween.start()
	exp_value.text = str(int(player.current_level_exp())) + " / " + str(int(player.next_level_exp_required())) + " Exp"

func connect_skills():
	for skill in player.get_skills():
		skill.connect("slottable_updated", self, "update_skills")

func apply_effect(effect):
	var new_effect = EffectIcon.instance()
	new_effect.initialize(effect)
	effects.add_child(new_effect)
