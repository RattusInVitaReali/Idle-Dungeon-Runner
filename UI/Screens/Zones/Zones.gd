extends Screen
class_name ZonesUI

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
	make_zones()
	CombatProcessor.connect("zone_changed", self, "_on_zone_changed")
	yield(get_parent(), "ready")
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

func get_zones():
	return $Zones.get_children()

func make_zones():
	for zone in zones:
		$Zones.add_child(zone.instance())
	for zone in get_zones():
		var zone_info = ZoneInfo.instance()
		zone_infos.add_child(zone_info)
		zone_info.set_zone(zone)
		zone_info.connect("play_zone", self, "_on_play_zone")
		zone_info.connect("inspector", self, "_on_inspector")
