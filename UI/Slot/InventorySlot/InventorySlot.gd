extends Slot
class_name InventorySlot

export (CraftingManager.ITEM_SUBTYPE) var item_subtype



func _ready():
	var inventory_icon = get_inventory_icon()
	icon.inventory_icon(inventory_icon)

func get_inventory_icon():
	var instance = CraftingManager.item_scenes[item_subtype].instance()
	var ret = instance.base_icon
	instance.queue_free()
	return ret
