extends Control
class_name Screen

const MaterialInspector = preload("res://UI/Inspectors/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspectors/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspectors/ItemInspector/ItemInspector.tscn")
const GearInspector = preload("res://UI/Inspectors/ItemInspector/GearInspector/GearInspector.tscn")
const SkillInspector = preload("res://UI/Inspectors/SkillInspector/SkillInspector.tscn")


func _on_inspector(slot, gear):
	var slottable = slot.slottable
	var inspector = null
	if slottable != null:
		match slottable.slottable_type:
			Slottable.SLOTTABLE_TYPE.MATERIAL:
				inspector = MaterialInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM_PART:
				inspector = PartInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM:
				if gear:
					inspector = GearInspector.instance()
				else:
					inspector = ItemInspector.instance()
			Slottable.SLOTTABLE_TYPE.SKILL:
				inspector = SkillInspector.instance()
		if inspector != null:
			add_child(inspector)
			inspector.set_slottable(slottable)
	return inspector
