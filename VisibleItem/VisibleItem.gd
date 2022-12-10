extends Node2D
class_name VisibleItem

var slottable = null

func _ready():
	for child in get_children():
		child.queue_free()

func set_slottable(_slottable):
	slottable = _slottable
	for child in get_children():
		remove_child(child)
		child.queue_free()
	if slottable == null:
		return
	if slottable.slottable_type != Slottable.SLOTTABLE_TYPE.ITEM:
		return
	for part_type in slottable.get_draw_order():
		for part in slottable.get_children():
			if part.type == part_type:
				var new_sprite = Sprite.new()
				new_sprite.texture = part.get_item_icon(slottable)
				new_sprite.modulate = part.icon_color
				add_child(new_sprite)
