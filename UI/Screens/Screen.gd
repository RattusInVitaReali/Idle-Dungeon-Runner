extends Control
class_name Screen

const MaterialInspector = preload("res://UI/Inspectors/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspectors/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspectors/ItemInspector/ItemInspector.tscn")
const SkillInspector = preload("res://UI/Inspectors/SkillInspector/SkillInspector.tscn")

var inspector = null

func _ready():
	get_parent().connect("lost_focus", self, "_on_lost_focus")

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

func _on_lost_focus():
	if inspector != null and weakref(inspector).get_ref():
		inspector.queue_free()
