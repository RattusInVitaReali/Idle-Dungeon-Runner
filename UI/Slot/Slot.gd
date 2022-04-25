extends TextureRect

signal inspector

const Frame = preload("res://_Resources/gui_images/Frame.png")
const FrameBasic = preload("res://_Resources/gui_images/Frame_Basic.png")
const FrameCommon = preload("res://_Resources/gui_images/Frame_Common.png")
const FrameUncommon = preload("res://_Resources/gui_images/Frame_Uncommon.png")
const FrameRare = preload("res://_Resources/gui_images/Frame_Rare.png")
const FrameEpic = preload("res://_Resources/gui_images/Frame_Epic.png")

const MaterialInspector = preload("res://UI/Inspector/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspector/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspector/ItemInspector/ItemInspector.tscn")

var slottable = null

func try_to_add_slottable(_slottable):
	if slottable == null:
		update_slot(_slottable)
		return slottable
	return null

func update_slot(_slottable):
	if slottable == _slottable:
		return
	slottable = _slottable
	if _slottable == null:
		texture = Frame
		$Icon.texture_normal = null
		$Quantity.visible = false
	else:
		match slottable.rarity:
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
		$Icon.texture_normal = slottable.icon
		$Quantity.text = str(slottable.quantity)
		if slottable.quantity > 1:
			$Quantity.visible = true
		else:
			$Quantity.visible = false

func _on_Icon_pressed():
	var inspector
	if slottable != null:
		match slottable.slottable_type:
			Slottable.SLOTTABLE_TYPE.MATERIAL:
				inspector = MaterialInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM_PART:
				inspector = PartInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM:
				inspector = ItemInspector.instance()
		emit_signal("inspector", inspector)
		inspector.set_slottable(slottable)

func test():
	var sword = CraftingManager.Sword.instance()
	sword.test()
	update_slot(sword)
