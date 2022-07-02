extends Node

signal bandit_boss_defeated

func _ready():
	CombatProcessor.connect("monster_died", self, "check_unlocks")

func check_unlocks(monster):
	if monster is BanditBoss:
		emit_signal("bandit_boss_defeated", monster.level)
