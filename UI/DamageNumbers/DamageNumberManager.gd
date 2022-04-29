extends Node2D

var DamageNumberLabel = preload("res://UI/DamageNumbers/DamageNumberLabel/DamageNumberLabel.tscn")

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

export (Color) var magic_color
export (Color) var phys_color
export (Color) var magic_crit_color
export (Color) var phys_crit_color


func new_damage_number(damage_info : CombatProcessor.DamageInfo):
	if (damage_info.phys_damage > 0):
		var new_label = DamageNumberLabel.instance()
		add_child(new_label)
		new_label.set_params(
			str(ceil(damage_info.phys_damage)), 
			phys_color, 
			phys_crit_color, 
			travel, 
			duration, 
			spread, 
			damage_info.is_crit
		)
	if (damage_info.magic_damage > 0):
		var new_label = DamageNumberLabel.instance()
		add_child(new_label)
		new_label.set_params(
			str(ceil(damage_info.magic_damage)), 
			magic_color, 
			magic_crit_color, 
			travel, 
			duration, 
			spread, 
			damage_info.is_crit
		)
	
