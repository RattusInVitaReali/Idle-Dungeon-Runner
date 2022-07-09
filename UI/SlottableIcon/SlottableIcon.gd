extends TextureRect
class_name SlottableIcon

const Locked = preload("res://_Resources/skill_icons/lock.png")

func set_slottable(var slottable : Slottable):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	if slottable == null:
		texture = null
		modulate = Color(1, 1, 1, 1)
		return
	match slottable.slottable_type:
		Slottable.SLOTTABLE_TYPE.ITEM:
			modulate = Color(1, 1, 1, 1)
			if slottable.get_child_count() == 0:
				texture = slottable.icon
			else:
				texture = null
			for part in slottable.get_children():
				var new_texture = TextureRect.new()
				new_texture.texture = part.item_icon
				new_texture.modulate = part.icon_color
				new_texture.expand = true
				new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
				new_texture.rect_size = rect_size
				add_child(new_texture)
		Slottable.SLOTTABLE_TYPE.SKILL:
			if slottable.locked:
				texture = Locked
				modulate = slottable.icon_color
			else:
				continue
		_:
			texture = slottable.icon
			modulate = slottable.icon_color
