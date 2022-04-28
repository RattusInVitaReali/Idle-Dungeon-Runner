extends TextureRect

signal inspector
signal test

const Frame = preload("res://_Resources/gui_images/Frame.png")
const FrameBasic = preload("res://_Resources/gui_images/Frame_Basic.png")
const FrameCommon = preload("res://_Resources/gui_images/Frame_Common.png")
const FrameUncommon = preload("res://_Resources/gui_images/Frame_Uncommon.png")
const FrameRare = preload("res://_Resources/gui_images/Frame_Rare.png")
const FrameEpic = preload("res://_Resources/gui_images/Frame_Epic.png")

const MaterialInspector = preload("res://UI/Inspectors/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/Inspectors/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/Inspectors/ItemInspector/ItemInspector.tscn")
const GearInspector = preload("res://UI/Inspectors/ItemInspector/GearInspector/GearInspector.tscn")

var gear = false

var slottable = null

func try_to_add_slottable(_slottable):
	if slottable == null:
		set_slottable(_slottable)
		return slottable
	return null

func set_slottable(_slottable):
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
	inspector()

func inspector():
	var inspector
	if slottable != null:
		match slottable.slottable_type:
			Slottable.SLOTTABLE_TYPE.MATERIAL:
				inspector = MaterialInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM_PART:
				inspector = PartInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM:
				if gear:
					inspector = GearInspector.instance()
				else:
					inspector = ItemInspector.instance()
		emit_signal("inspector", inspector)
		inspector.set_slottable(slottable)

func test():
	var sword = CraftingManager.Sword.instance()
	sword.test()
	set_slottable(sword)
