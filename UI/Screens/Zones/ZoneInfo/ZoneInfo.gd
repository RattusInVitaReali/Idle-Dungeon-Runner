extends NinePatchRect
class_name ZoneInfo

signal play_zone

onready var zone_level = $ZoneBackground/HBoxContainer/LevelDisplay/Level
onready var zone_name = $ZoneBackground/HBoxContainer/ZoneName

onready var buttons = [
	$ZoneBackground/HBoxContainer/LevelControl/LevelUp,
	$ZoneBackground/HBoxContainer/LevelControl/LevelDown,
	$ZoneBackground/HBoxContainer/Play
]

var zone : Zone = null;

func set_zone(zone_scene : PackedScene):
	zone = zone_scene.instance()
	add_child(zone)
	zone.connect("unlocked", self, "update_zone")
	update_zone()

func _on_LevelUp_pressed():
	zone.level_up()
	update_level()

func _on_LevelDown_pressed():
	zone.level_down()
	update_level()

func _on_Play_pressed():
	play_zone()

func play_zone():
	emit_signal("play_zone", zone)

func update_level():
	if zone.locked:
		zone_level.text = "Level\n???"
	else:
		zone_level.text = "Level\n" + str(zone.level)

func update_name():
	if zone.locked:
		zone_name.text = "LOCKED"
	else:
		zone_name.text = zone.zone_name + '\n' + str(zone.min_level) + " - " + str(zone.max_level)

func update_background():
	if zone.locked:
		$ZoneBackground.texture = null
	else:
		var new_atlas = AtlasTexture.new()
		new_atlas.atlas = zone.texture
		new_atlas.region = Rect2(270, 500, 1040, 260)
		$ZoneBackground.texture = new_atlas

func update_buttons():
	for button in buttons:
		if zone.locked:
			button.disabled = true
		else:
			button.disabled = false

func update_zone():
	update_level()
	update_name()
	update_background()
	update_buttons()
