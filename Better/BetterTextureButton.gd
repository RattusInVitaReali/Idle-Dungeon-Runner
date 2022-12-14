extends TextureButton
class_name BetterTextureButton

export (AudioStream) var button_sound = preload("res://RESOURCES/Sound/ButtonSound.wav")

func _ready():
	$AudioStreamPlayer.stream = button_sound

func _on_BetterTextureButton_pressed() -> void:
	if GlobalSettings.sound_enabled:
		$AudioStreamPlayer.play()
