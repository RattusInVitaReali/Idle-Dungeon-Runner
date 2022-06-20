extends Control
class_name Inspector

const StatLabel = preload("res://UI/Inspectors/StatLabel.tscn")

onready var slottable_name = $Panel/VBoxContainer/Name
onready var rarity = $Panel/VBoxContainer/Rarity
onready var icon = $Panel/VBoxContainer/Image/Icon
onready var stats_container = $Panel/VBoxContainer/Stats/StatsContainer
onready var special = $Panel/VBoxContainer/Special

var slottable

func set_slottable(_slottable):
	slottable = _slottable
	update_name()
	update_rarity()
	update_icon()
	update_stats()
	update_special()

func update_name():
	slottable_name.text = slottable.slottable_name

func update_rarity():
	rarity.text = CraftingManager.RARITY.keys()[slottable.rarity].capitalize() + " "
	match slottable.slottable_type:
		Slottable.SLOTTABLE_TYPE.ITEM:
			rarity.text += CraftingManager.ITEM_SUBTYPE.keys()[slottable.subtype].capitalize()
		Slottable.SLOTTABLE_TYPE.ITEM_PART:
			rarity.text += CraftingManager.PART_TYPE.keys()[slottable.type].capitalize()
		Slottable.SLOTTABLE_TYPE.MATERIAL:
			rarity.text += CraftingManager.MATERIAL_TYPE.keys()[slottable.type].capitalize()
		Slottable.SLOTTABLE_TYPE.SKILL:
			rarity.text += "Skill"

func update_icon():
	icon.texture = slottable.icon

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
	special.text = slottable.special

func _on_TextureButton_pressed():
	queue_free()
