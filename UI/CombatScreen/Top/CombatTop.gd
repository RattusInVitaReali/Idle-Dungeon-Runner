extends Control

const EffectIcon = preload("res://UI/CombatScreen/EffectIcon/EffectIcon.tscn")

onready var zone_info = $Main/HigherBackground/Background/VBoxContainer/Background/ZoneInfo
onready var quest_info = $Main/HigherBackground/Background/VBoxContainer/Quest/QuestBar/QuestInfo
onready var quest_bar = $Main/HigherBackground/Background/VBoxContainer/Quest/QuestBar
onready var quest_bar_tween = $Main/HigherBackground/Background/VBoxContainer/Quest/QuestBar/QuestTween

onready var monster_name = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Name
onready var monster_modifiers = $Main/LowerBackground/VBoxContainer/MonsterInfo/VBoxContainer/Modifiers
onready var monster_hp_bar = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP
onready var monster_hp_value = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/HPValue
onready var monster_hp_tween = $Main/LowerBackground/VBoxContainer/HBoxContainer/MonsterHP/Tween

onready var effects = $Main/Effects

var monster = null
var zone = null
var quest = null

func _ready():
	CombatProcessor.connect("monster_spawned", self, "update_monster_info")
	CombatProcessor.connect("quest_changed", self, "change_quest")
	CombatProcessor.connect("zone_changed", self, "change_zone")

func update_monster_info(_monster):
	monster = _monster
	monster.connect("hp_updated", self, "update_monster_hp")
	monster.connect("effect_applied", self, "apply_effect")
	update_monster_name()
	update_monster_hp()
	update_monster_modifiers()

func update_monster_name():
	monster_name.text = monster.monster_name

func update_monster_modifiers():
	var text = ""
	for prefix in monster.prefixes:
		text += prefix + " - "
	for suffix in monster.suffixes:
		text += suffix + " - "
	text.erase(text.length() - 3, 3)
	monster_modifiers.text = text

func update_monster_hp():
	monster_hp_bar.max_value = monster.stats.max_hp
	monster_hp_tween.interpolate_property(
		monster_hp_bar, 
		"value", 
		monster_hp_bar.value, 
		monster.stats.hp, 
		0.2, Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	monster_hp_tween.start()
	monster_hp_value.text = str(int(monster.stats.hp)) + " HP"

func apply_effect(effect):
	var new_effect = EffectIcon.instance()
	new_effect.initialize(effect)
	effects.add_child(new_effect)

func change_zone(_zone):
	zone = _zone
	zone.connect("zone_updated", self, "update_zone")
	update_zone()

func update_zone():
	zone_info.text = zone.get_zone_info()

func change_quest(_quest):
	quest = _quest
	quest.connect("quest_updated", self, "update_quest")
	update_quest()

func update_quest():
	quest_bar.max_value = quest.required_kills * 10
	quest_bar_tween.interpolate_property(
		quest_bar, 
		"value", 
		quest_bar.value, 
		quest.kill_count * 10, 
		0.2, Tween.TRANS_LINEAR, 
		Tween.EASE_OUT
	)
	quest_bar_tween.start()
	quest_info.text = quest.quest_info()
