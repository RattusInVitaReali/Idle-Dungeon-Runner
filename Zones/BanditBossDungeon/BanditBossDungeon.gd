extends Zone

# Kinda hacky but works for now - doesn't call the overriden function which is bad, fix sometime
func _on_monster_despawned():
	zone_floor += 1
	max_level = level + 10
	min_level = max_level
	max_level_reached = max_level
	set_level(min_level)
	emit_signal("zone_updated")
