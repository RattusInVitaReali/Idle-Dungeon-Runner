extends AudioStreamPlayer
class_name CombatSounds

var OnHit = preload("res://RESOURCES/Sound/Combat/OnHit.mp3")

func play_on_hit():
	stream = OnHit
	play(0.13)
