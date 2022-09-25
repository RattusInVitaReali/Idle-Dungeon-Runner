extends SlottableInspector
class_name StatsInspector

const StatLabel = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/StatLabel.tscn")
const TierStar = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/TierStar/TierStar.tscn")

onready var stats_container = $Panel/VBoxContainer/Stats/StatsContainer
onready var special = $Panel/VBoxContainer/Special
onready var special_line = $Panel/VBoxContainer/Line2
onready var tier_stars = $Panel/VBoxContainer/TierStars/TierStarsContainer
onready var tier_line = $Panel/VBoxContainer/TierLine

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_stats()
	update_special()
	update_tier_stars()

func update_stats():
	for stat in stats_container.get_children():
		stats_container.remove_child(stat)
		stat.queue_free()
	for stat in slottable.stats:
		if slottable.stats[stat] != 0:
			var new_label = StatLabel.instance()
			new_label.text = "+ " + str(slottable.stats[stat]) + " " + stat.capitalize()
			stats_container.add_child(new_label)

func update_special():
	pass

func update_tier_stars():
	for star in tier_stars.get_children():
		star.queue_free()
	if slottable.tier > 0:
		tier_stars.show()
		tier_line.show()
		var i = floor(slottable.tier / 5)
		while i > 0:
			tier_stars.add_child(TierStar.instance().set_tier(1))
			i -= 1
		i = int(slottable.tier) % 5
		while i > 0:
			tier_stars.add_child(TierStar.instance().set_tier(0))
			i -= 1
	else:
		tier_stars.hide()
		tier_line.hide()
