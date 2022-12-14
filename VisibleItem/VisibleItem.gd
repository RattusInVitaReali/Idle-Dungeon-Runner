extends Node2D
class_name VisibleItem

export var invert_offset_x = false

var slottable = null

func _ready():
	for sprite in $Sprites.get_children():
		sprite.queue_free()
	if invert_offset_x:
		$Trail2D.base_offset.x = -$Trail2D.base_offset.x

func set_slottable(_slottable):
	slottable = _slottable
	for sprite in $Sprites.get_children():
		sprite.queue_free()
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
				$Sprites.add_child(new_sprite)

func set_emit(_emit):
	$Trail2D.emit = _emit
