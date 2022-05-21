extends Control

func player_spawned(player):
	$CombatBottom.update_info(player)

func monster_spawned(monster):
	$CombatTop.update_monster_info(monster)

func quest_changed(quest):
	$CombatTop.change_quest(quest)

func zone_changed(zone):
	$CombatTop.change_zone(zone)
