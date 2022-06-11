extends GameScreen

func _ready():
	$Zones.connect("play_zone", self, "_on_play_zone")

func _on_play_zone(zone):
	CombatProcessor.emit_signal("zone_changed", zone)
