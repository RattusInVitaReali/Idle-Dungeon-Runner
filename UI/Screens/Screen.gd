extends Control
class_name Screen

const MaterialInspector = preload("res://UI/Inspectors/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspectors/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspectors/ItemInspector/ItemInspector.tscn")
const GearInspector = preload("res://UI/Inspectors/ItemInspector/GearInspector/GearInspector.tscn")

func _on_inspector(slottable, gear):
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
		add_child(inspector)
		inspector.set_slottable(slottable)
	return inspector
