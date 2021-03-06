extends Screen
class_name CombatUI

func player_spawned(player):
	$CombatBottom.update_info(player)

func monster_spawned(monster):
	$CombatTop.update_monster_info(monster)

func quest_changed(quest):
	$CombatTop.change_quest(quest)

func zone_changed(zone):
	$CombatTop.change_zone(zone)

func player_level_changed():
	$CombatBottom.update_player_level()

func player_exp_changed():
	$CombatBottom.update_player_exp()

func _on_lost_focus():
	._on_lost_focus()
	if !CombatProcessor.auto_combat:
		$CombatModeButton.force_auto_combat()
