extends Node
class_name RandomScript

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
