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
				new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				new_texture.rect_size = rect_size
				add_child(new_texture)
		Slottable.SLOTTABLE_TYPE.SKILL:
			texture = slottable.border_texture
			var new_texture = TextureRect.new()
			new_texture.expand = true
			new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			new_texture.show_behind_parent = true
			new_texture.margin_left = 15
			new_texture.margin_right = -15
			new_texture.margin_top = 15
			new_texture.margin_bottom = -15
			new_texture.rect_size = Vector2(rect_size.x - 30, rect_size.y - 30)
			if slottable.locked:
				new_texture.texture = Locked
			else:
				new_texture.texture = slottable.icon
			add_child(new_texture)
		_:
			texture = slottable.icon
			modulate = slottable.icon_color
