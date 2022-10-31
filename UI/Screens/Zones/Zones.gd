extends Screen
class_name ZonesUI

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
	
	preload( "res://Zones/IcyCliffs/IcyCliffs.tscn"),
	
	preload("res://Zones/Ruins/Ruins.tscn"),
	
	preload("res://Zones/AshfallenForest/AshfallenForest.tscn")
]

onready var zone_infos = $VBoxContainer/Screen/VBoxContainer/ScrollContainer/ZoneInfos

var idle_zone = null

func _ready():
	Saver.save_on_exit(self)
	self.load()
	yield(get_parent(), "ready")
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")
	starter_zone()

func _notification(what):
	if what == MainLoop.NOTIFICATION_APP_RESUMED:
		starter_zone()

func _on_play_zone(zone):
	CombatProcessor.change_zone(zone)

func _on_zone_changed(zone):
	if zone.can_idle_here():
		if idle_zone != null:
			idle_zone.idle_here = false
		idle_zone = zone
		idle_zone.idle_here = true

func starter_zone():
	for zone_info in zone_infos.get_children():
		if zone_info.zone.idle_here:
			zone_info.play_zone()
			return
	var starter = zone_infos.get_child(0)
	starter.play_zone()
	Saver.get_idle_rewards()

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
		zone_info.connect("inspector", self, "_on_inspector")

func save_and_exit():
	if $Zones.get_child_count() != 0:
		Saver.save_scene($Zones, save_path)
