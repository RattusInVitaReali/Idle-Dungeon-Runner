extends Zone

func _on_monster_despawned():
	._on_monster_despawned()
	max_level = level + 5
	min_level = max_level
	self.level = min_level
