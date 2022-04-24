extends TextureRect

const Frame = preload("res://Resources/gui_images/Frame.png")
const FrameBasic = preload("res://Resources/gui_images/Frame_Basic.png")
const FrameCommon = preload("res://Resources/gui_images/Frame_Common.png")
const FrameUncommon = preload("res://Resources/gui_images/Frame_Uncommon.png")
const FrameRare = preload("res://Resources/gui_images/Frame_Rare.png")
const FrameEpic = preload("res://Resources/gui_images/Frame_Epic.png")

var item = null

func try_to_add_item(_item):
	if item == null:
		update_slot(_item)
		return item
	return null

func update_slot(_item):
	if item == _item:
		return
	item = _item
	if _item == null:
		texture = Frame
		$Icon.texture_normal = null
		$Quantity.visible = false
	else:
		match item.rarity:
			CraftingManager.RARITY.BASIC:
				texture = FrameBasic
			CraftingManager.RARITY.COMMON:
				texture = FrameCommon
			CraftingManager.RARITY.UNCOMMON:
				texture = FrameUncommon
			CraftingManager.RARITY.RARE:
				texture = FrameRare
			CraftingManager.RARITY.EPIC:
				texture = FrameEpic
		$Icon.texture_normal = item.icon
		$Quantity.text = str(item.quantity)
		if item.quantity > 1:
			$Quantity.visible = true
		else:
			$Quantity.visible = false

func _ready():
	pass
