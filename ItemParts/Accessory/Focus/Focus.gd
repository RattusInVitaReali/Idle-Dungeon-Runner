extends ItemPart
class_name Focus

export (Texture) var amulet_icon
export (Texture) var ring_icon

func get_item_icon(item : Item):
	match item.subtype:
		CraftingManager.ITEM_SUBTYPE.AMULET:
			return amulet_icon
		CraftingManager.ITEM_SUBTYPE.RING:
			return ring_icon
