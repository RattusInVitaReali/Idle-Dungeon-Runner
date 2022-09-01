extends Control
class_name Screen

const MaterialInspector = preload("res://UI/Inspectors/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspectors/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspectors/ItemInspector/ItemInspector.tscn")
const SkillInspector = preload("res://UI/Inspectors/SkillInspector/SkillInspector.tscn")

var inspector = null

var player : Player = null

func _ready():
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")
	rect_size = ScreenMeasurer.get_screen_size()

func _on_player_spawned(_player):
	player = _player

func _on_inspector(slot):
	var slottable = slot.slottable
	inspector = null
	if slottable != null:
		match slottable.slottable_type:
			Slottable.SLOTTABLE_TYPE.MATERIAL:
				inspector = MaterialInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM_PART:
				inspector = PartInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM:
				inspector = ItemInspector.instance()
			Slottable.SLOTTABLE_TYPE.SKILL:
				inspector = SkillInspector.instance()
		if inspector != null:
			add_child(inspector)
			inspector.set_slot(slot)
	return inspector

func on_focused():
	pass

func on_lost_focus():
	if inspector != null and weakref(inspector).get_ref():
		inspector.queue_free()
