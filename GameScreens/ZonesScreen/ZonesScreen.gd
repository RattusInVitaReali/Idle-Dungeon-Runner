extends GameScreen
class_name ZonesScreen

func _ready():
	$Zones.connect("play_zone", self, "_on_play_zone")

func _on_play_zone(zone):
	CombatProcessor.change_zone(zone)
