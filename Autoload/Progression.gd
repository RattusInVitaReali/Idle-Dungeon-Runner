extends Node

signal progression_monster_died

func _ready():
	CombatProcessor.connect("monster_died", self, "_on_monster_died")

func _on_monster_died(monster, zone):
	emit_signal("progression_monster_died", monster, zone)
