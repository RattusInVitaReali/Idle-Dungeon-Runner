extends ItemPart
class_name Crown

export (Texture) var amulet_item_icon
export (Texture) var ring_item_icon

func get_item_icon(item):
	match item.item_subtype:
		CraftingManager.ITEM_SUBTYPE.RING:
			item_icon = null
		CraftingManager.ITEM_SUBTYPE.AMULET:
			item_icon = null
	return item_icon
