extends Control

const EffectIcon = preload("res://UI/CombatScreen/EffectIcon/EffectIcon.tscn")

onready var zone_info = $Main/HigherBackground/Background/VBoxContainer/Background/ZoneInfo
onready var monster_name = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Name
onready var monster_modifiers = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Modifiers
onready var monster_hp_bar = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP
onready var monster_hp_value = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/HPValue
onready var monster_hp_tween = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/Tween
onready var effects = $Main/Effects

func _ready():
	CombatProcessor.connect("entered_combat", self, "update")
	CombatProcessor.connect("monster_spawned", self, "update")
	CombatProcessor.connect("monster_hp_updated", self, "update_monster_hp")
	CombatProcessor.connect("effect_applied", self, "apply_effect")

func update():
	update_zone_info()
	update_monster_info()

# No more zone info, add parameter zone_info and call using a signal
func update_zone_info():
	zone_info.text = CombatProcessor.Zone.get_zone_info()

func update_monster_info():
	update_monster_name()
	update_monster_hp()
	update_monster_modifiers()

func update_monster_name():
	monster_name.text = CombatProcessor.Monster.monster_name

func update_monster_modifiers():
	var text = ""
	for prefix in CombatProcessor.Monster.prefixes:
		text += prefix + " - "
	for suffix in CombatProcessor.Monster.suffixes:
		text += suffix + " - "
	text.erase(text.length() - 3, 3)
	monster_modifiers.text = text

func update_monster_hp():
	monster_hp_bar.max_value = CombatProcessor.Monster.stats.max_hp
	monster_hp_tween.interpolate_property(
		monster_hp_bar, 
		"value", 
		monster_hp_bar.value, 
		CombatProcessor.Monster.stats.hp, 
		0.2, Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	monster_hp_tween.start()
	monster_hp_value.text = str(int(CombatProcessor.Monster.stats.hp)) + " HP"

func apply_effect(effect):
	if effect.target == CombatProcessor.Monster:
		var new_effect = EffectIcon.instance()
		new_effect.initialize(effect)
		effects.add_child(new_effect)
