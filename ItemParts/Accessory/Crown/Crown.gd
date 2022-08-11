extends ItemPart
class_name Crown

export (Texture) var amulet_item_icon
export (Texture) var ring_item_icon

func get_item_icon(item):
	match item.subtype:
		CraftingManager.ITEM_SUBTYPE.RING:
			item_icon = ring_item_icon
		CraftingManager.ITEM_SUBTYPE.AMULET:
			item_icon = amulet_item_icon
	return item_icon
