extends ItemPart
class_name HelmetProtection

export (Texture) var leather_icon
export (Texture) var metal_icon

export (Texture) var leather_item_icon
export (Texture) var metal_item_icon

func get_part_icon():
	if mat == null:
		return icon
	match mat.type:
		CraftingManager.MATERIAL_TYPE.WOOD:
			icon = metal_icon
		CraftingManager.MATERIAL_TYPE.METAL:
			icon = metal_icon
		CraftingManager.MATERIAL_TYPE.LEATHER:
			icon = leather_icon
	return icon

func get_item_icon(item):
	if mat == null:
		return item_icon
	match mat.type:
		CraftingManager.MATERIAL_TYPE.WOOD:
			item_icon = metal_item_icon
		CraftingManager.MATERIAL_TYPE.METAL:
			item_icon = metal_item_icon
		CraftingManager.MATERIAL_TYPE.LEATHER:
			item_icon = leather_item_icon
	return item_icon
