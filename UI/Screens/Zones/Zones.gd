extends Screen

signal play_zone

const ZoneInfo = preload("res://UI/Screens/Zones/ZoneInfo/ZoneInfo.tscn")

const zones = [
	preload("res://Zones/Forest/Variants/ForestEasy.tscn"),
	preload("res://Zones/Forest/Variants/ForestMedium.tscn"),
	preload("res://Zones/Forest/Variants/ForestHard.tscn"),

	preload("res://Zones/Desert/Variants/DesertEasy.tscn"),
	preload("res://Zones/Desert/Variants/DesertMedium.tscn"),
	preload("res://Zones/Desert/Variants/DesertHard.tscn"),
	
	preload("res://Zones/Ruins/Ruins.tscn")
]

onready var zone_infos = $VBoxContainer/Screen/VBoxContainer/ScrollContainer/ZoneInfos

func _ready():
	for zone in zones:
		var zone_info = ZoneInfo.instance()
		zone_infos.add_child(zone_info)
		zone_info.set_zone(zone)
		zone_info.connect("play_zone", self, "_on_play_zone")
	yield(get_parent(), "ready")
	starter_zone()

func _on_play_zone(zone):
	emit_signal("play_zone", zone)

func starter_zone():
	var starter = zone_infos.get_child(0)
	starter.play_zone()
