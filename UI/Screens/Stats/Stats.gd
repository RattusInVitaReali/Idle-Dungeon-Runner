extends Screen
class_name StatsUI

const Stat = preload("res://UI/Screens/Stats/Stat/Stat.tscn")

onready var stats_container = $VBoxContainer/Screen/VBoxContainer/NinePatchRect/TextureRect/ScrollContainter/StatsContainer

var player = null

func _ready():
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")

func _on_player_spawned(_player):
	if _player != player:
		player = _player
		player.connect("stats_updated", self, "update_stats")
		player.connect("hp_updated", self, "update_hp")
		update_stats()

func update_stats():
	var stats = player.stats
	for child in stats_container.get_children():
		child.queue_free()
	for stat in stats:
		var new_stat = Stat.instance()
		stats_container.add_child(new_stat)
		new_stat.init(stat.capitalize(), str(stats[stat]))

func update_hp():
	for child in stats_container.get_children():
		if child.stat_name.text == "Hp":
			child.value.text = str(player.stats["hp"])
			return
