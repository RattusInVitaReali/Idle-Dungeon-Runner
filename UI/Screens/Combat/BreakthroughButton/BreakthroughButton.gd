extends Control
class_name BreakthroughButton

const BreakthroughFrame = preload("res://_Resources/gui_images/Frame_Legendary.png")
const RepeatFrame = preload("res://_Resources/gui_images/Frame_Uncommon.png")
const Infinity = preload("res://_Resources/infinity.png")
const UpArrow = preload("res://_Resources/gui_images/UpArrow.png")

onready var texture = $TextureButton/TextureRect

func _ready():
	CombatProcessor.connect("breakthrough_updated", self, "_on_breakthrough_changed")

func _on_breakthrough_changed():
	if CombatProcessor.breakthrough:
		$TextureButton.texture_normal = BreakthroughFrame
		texture.texture = UpArrow
	else:
		$TextureButton.texture_normal = RepeatFrame
		texture.texture = Infinity

func _on_TextureButton_pressed():
	CombatProcessor.breakthrough = !CombatProcessor.breakthrough
