extends Node

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
