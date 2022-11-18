extends Screen
class_name CombatUI

var monster : Monster = null

func _ready():
	CombatProcessor.connect("monster_spawned", self, "_on_monster_spawned")

func _on_player_spawned(_player):
	._on_player_spawned(_player)
	$CombatBottom.update_info(player)

func _on_monster_spawned(_monster):
	monster = _monster
	$CombatTop.update_monster_info(monster)

func on_lost_focus():
	.on_lost_focus()
	if !CombatProcessor.auto_combat:
		$CombatModeButton.force_auto_combat()

func _on_NextSkill_pressed():
	if !CombatProcessor.auto_combat:
		player.next_action(true)

func _on_Music_toggled(button_pressed: bool) -> void:
	GlobalSettings.music_enabled = !button_pressed

func _on_Sound_toggled(button_pressed: bool) -> void:
	GlobalSettings.sound_enabled = !button_pressed
