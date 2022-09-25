extends PartInspector
class_name PartCompareInspector

signal confirmed

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

onready var lost_special = $Panel/VBoxContainer/LostSpecial

var compare_to = null

func set_compare_to(var part):
	compare_to = part
	update_compare_stats()
	update_compare_special()

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

func update_compare_special():
	if compare_to == null:
		lost_special.hide()
		special.add_color_override("font_color", Color.green)
		return
	if slottable.special == compare_to.special and slottable.special != "":
		lost_special.hide()
		return
	special.add_color_override("font_color", Color.red)
	if compare_to.special == "":
		lost_special.hide()
	else:
		lost_special.text = compare_to.special

func _on_Button1_pressed():
	emit_signal("confirmed", true)
	queue_free()

func _on_Button2_pressed():
	emit_signal("confirmed", false)
	queue_free()

func _on_TextureButton_pressed():
	_on_Button2_pressed()
