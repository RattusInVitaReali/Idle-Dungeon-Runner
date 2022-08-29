extends HBoxContainer
class_name Slot

signal inspector

const TierStar = preload("res://UI/Slot/SlotTierStar/SlotTierStar.tscn")

const Frame = preload("res://_Resources/gui_images/Frame.png")
const FrameBasic = preload("res://_Resources/gui_images/Frame_Basic.png")
const FrameCommon = preload("res://_Resources/gui_images/Frame_Common.png")
const FrameUncommon = preload("res://_Resources/gui_images/Frame_Uncommon.png")
const FrameRare = preload("res://_Resources/gui_images/Frame_Rare.png")
const FrameEpic = preload("res://_Resources/gui_images/Frame_Epic.png")

export var gear = false
export var upgrade = false
export var hide_quantity = false

var slottable = null

onready var icon = $Background/SlottableIcon
onready var quantity = $Background/Quantity
onready var selection = $Background/Selection
onready var tier_stars = $Background/TierStars
onready var button = $Background/Button

func try_to_add_slottable(_slottable):
	if slottable == null:
		set_slottable(_slottable)
		return slottable
	return null

func set_slottable(_slottable):
	if slottable != null:
		slottable.disconnect("slottable_updated", self, "update_slot")
		if !gear and !upgrade:
			slottable.disconnect("tree_exited", self, "_on_slottable_tree_exited")
	slottable = _slottable
	if slottable != null:
		slottable.connect("slottable_updated", self, "update_slot")
		if !gear and !upgrade:
			slottable.connect("tree_exited", self, "_on_slottable_tree_exited")
	update_slot()

func _on_slottable_tree_exited():
	if slottable.is_queued_for_deletion():
		queue_free()

func update_slot():
	if icon == null:
		return
	icon.set_slottable(slottable)
	if slottable == null:
		$Background.texture = Frame
		quantity.visible = false
		for tier_star in tier_stars.get_children():
			tier_stars.remove_child(tier_star)
			tier_star.queue_free()
	else:
		match slottable.rarity:
			CraftingManager.RARITY.BASIC:
				$Background.texture = FrameBasic
			CraftingManager.RARITY.COMMON:
				$Background.texture = FrameCommon
			CraftingManager.RARITY.UNCOMMON:
				$Background.texture = FrameUncommon
			CraftingManager.RARITY.RARE:
				$Background.texture = FrameRare
			CraftingManager.RARITY.EPIC:
				$Background.texture = FrameEpic
		if !(gear or upgrade or hide_quantity):
			quantity.text = str(slottable.quantity)
			quantity.visible = true
		for tier_star in tier_stars.get_children():
			tier_stars.remove_child(tier_star)
			tier_star.queue_free()
		var i = floor(slottable.tier / 5)
		while i > 0:
			tier_stars.add_child(TierStar.instance().set_tier(1))
			i -= 1
		i = int(slottable.tier) % 5
		while i > 0:
			tier_stars.add_child(TierStar.instance().set_tier(0))
			i -= 1
		tier_stars.visible = true

func _on_Button_pressed():
	if slottable != null:
		inspector()

func inspector():
	emit_signal("inspector", self)

func select():
	selection.show()

func deselect():
	selection.hide()

func toggle_selection():
	if selection.visible:
		deselect()
	else:
		select()
