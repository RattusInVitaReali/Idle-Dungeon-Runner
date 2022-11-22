extends AudioStreamPlayer
class_name BetterAudioStreamPlayer

func play(from = 0.0):
	if GlobalSettings.sound_enabled and get_tree().root.get_node("Main").curr_screen == Main.SCREEN.COMBAT:
		.play(from)
