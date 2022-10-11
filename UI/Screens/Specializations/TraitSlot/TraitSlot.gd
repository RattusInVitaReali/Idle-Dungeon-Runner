extends TextureRect
class_name TraitSlot

const BorderDefault = preload("res://RESOURCES/SkillBorders/Border3.png")
const BorderSelected = preload("res://RESOURCES/SkillBorders/Border4.png")

export (Resource) var trait
export (bool) var selected = false;

func _ready():
	if trait != null:
		set_trait(trait)

func set_trait(_trait):
	trait = _trait
	$TextureButton.texture_normal = trait.trait_icon
