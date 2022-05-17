extends TextureRect

signal inspector
signal test

const Frame = preload("res://_Resources/gui_images/Frame.png")
const FrameBasic = preload("res://_Resources/gui_images/Frame_Basic.png")
const FrameCommon = preload("res://_Resources/gui_images/Frame_Common.png")
const FrameUncommon = preload("res://_Resources/gui_images/Frame_Uncommon.png")
const FrameRare = preload("res://_Resources/gui_images/Frame_Rare.png")
const FrameEpic = preload("res://_Resources/gui_images/Frame_Epic.png")

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
		if (slottable.slottable_type == Slottable.SLOTTABLE_TYPE.MATERIAL):
			$Quantity.text = str(slottable.quantity)
			$Quantity.visible = true
		else:
			$Quantity.visible = false

func _on_Icon_pressed():
	if slottable != null:
		inspector()

func inspector():
	emit_signal("inspector", self, gear)

func test():
	var sword = CraftingManager.Sword.instance()
	sword.test()
	set_slottable(sword)

func select():
	$Selection.show()

func deselect():
	$Selection.hide()

func toggle_selection():
	if $Selection.visible:
		deselect()
	else:
		select()
