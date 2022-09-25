extends TextureRect
class_name TierStar

const Yellow = preload("res://RESOURCES/GuiImages/TierStarYellow.png")
const Red = preload("res://RESOURCES/GuiImages/TierStarRed.png")
const Purple = preload("res://RESOURCES/GuiImages/TierStarPurple.png")

const tier_icons = {
	0 : Yellow,
	1 : Red,
	2 : Purple
}

func set_tier(tier):
	texture = tier_icons[tier]
	return self

