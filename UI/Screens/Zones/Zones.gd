extends Screen
class_name ZonesUI

signal play_zone

const save_path = "user://zones.tscn"

const ZoneInfo = preload("res://UI/Screens/Zones/ZoneInfo/ZoneInfo.tscn")

const zones = [
	preload("res://Zones/Forest/Variants/ForestEasy.tscn"),
	preload("res://Zones/Forest/Variants/ForestMedium.tscn"),
	preload("res://Zones/Forest/Variants/ForestHard.tscn"),
	
	preload("res://Zones/BanditBossDungeon/BanditBossDungeon.tscn"),
	
	preload("res://Zones/Desert/Variants/DesertEasy.tscn"),
	preload("res://Zones/Desert/Variants/DesertMedium.tscn"),
	preload("res://Zones/Desert/Variants/DesertHard.tscn"),
	
	preload("res://Zones/Ruins/Ruins.tscn")
]

onready var zone_infos = $VBoxContainer/Screen/VBoxContainer/ScrollContainer/ZoneInfos

func _ready():
	Saver.save(self)
	self.load()
	yield(get_parent(), "ready")
	starter_zone()

func _on_play_zone(zone):
	emit_signal("play_zone", zone)

func starter_zone():
	var starter = zone_infos.get_child(0)
	starter.play_zone()

func load():
	if ResourceLoader.exists(save_path):
		var saved = load(save_path).instance()
		for zone in saved.get_children():
			saved.remove_child(zone)
			$Zones.add_child(zone)
	else:
		for zone in zones:
			$Zones.add_child(zone.instance())
	for zone in $Zones.get_children():
		var zone_info = ZoneInfo.instance()
		zone_infos.add_child(zone_info)
		zone_info.set_zone(zone)
		zone_info.connect("play_zone", self, "_on_play_zone")
		

func save_and_exit():
	if save_path != "" and $Zones.get_child_count() != 0:
		Saver.save_scene($Zones, save_path)
