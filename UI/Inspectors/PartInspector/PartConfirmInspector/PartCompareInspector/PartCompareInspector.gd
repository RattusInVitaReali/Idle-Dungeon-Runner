extends PartConfirmInspector
class_name PartCompareInspector

const null_stats = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

var compare_to = null

func set_compare_to(var part):
	compare_to = part
	update_compare_stats()

func update_compare_stats():
	for stat in stats_container.get_children():
		stats_container.remove_child(stat)
		stat.queue_free()
	var compare_to_stats = null_stats
	if compare_to != null:
		compare_to_stats = compare_to.stats
	for stat in slottable.stats:
		if !slottable.stats[stat] == 0 or !compare_to_stats[stat] == 0:
			var new_label = StatLabel.instance()
			new_label.text = "+ " + str(slottable.stats[stat]) + " " + stat.capitalize()
			if slottable.stats[stat] > compare_to_stats[stat]:
				new_label.add_color_override("font_color", Color(0, 1, 0, 1))
			elif slottable.stats[stat] < compare_to_stats[stat]:
				new_label.add_color_override("font_color", Color(1, 0, 0, 1))
			stats_container.add_child(new_label)
