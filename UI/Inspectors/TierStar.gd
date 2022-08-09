extends TextureRect
class_name TierStar

const Yellow = preload("res://_Resources/icons2/image_part_292.png")
const Red = preload("res://_Resources/icons2/image_part_289.png")
const Purple = preload("res://_Resources/icons2/image_part_293.png")

const tier_icons = {
	0 : Yellow,
	1 : Red,
	2 : Purple
}

func set_tier(tier):
	texture = tier_icons[tier]
	return self

