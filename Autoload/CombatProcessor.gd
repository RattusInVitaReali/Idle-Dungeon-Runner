extends Node

var Bleeding = load("res://Effects/Bleeding/Bleeding.tscn")

signal entered_combat
signal exited_combat
signal next_combat_ready
signal monster_hp_updated
signal player_hp_updated
signal monster_spawned
signal player_spawned
signal entered_auto_combat
signal entered_manual_combat
signal used_skill
signal effect_applied
signal manual_use_skill

signal items_changed

var Monster
var Player
var Zone

var in_combat = false

var auto_combat = true

class DamageInfo:
	
	var attacker = null
	var target = null
	var phys_damage = 0
	var magic_damage = 0
	var can_crit = true
	var effects = []
	var dot_tick = false
	var bleeding_tick = false
	
	var is_crit = false
	
	func _init(_attacker, _target):
		attacker = _attacker
		target = _target
		return self

	func phys_damage(_phys_damage):
		phys_damage = _phys_damage
		return self
	
	func magic_damage(_magic_damage):
		magic_damage = _magic_damage
		return self

	func can_crit(_can_crit):
		can_crit = _can_crit
		return self

	func effect(effect_info):
		effects.append(effect_info)
		return self

	func dot_tick(_dot_tick):
		dot_tick = _dot_tick
		return self

	func bleeding_tick(_bleeding_tick):
		bleeding_tick = _bleeding_tick
		dot_tick = _bleeding_tick
		return self

	func apply_crit(crit_multi):
		phys_damage *= crit_multi
		magic_damage *= crit_multi
		can_crit = false
		is_crit = true
		for effect in effects:
			effect.apply_crit()
		return self

func damage_enemy(damage_info):
	damage_info.target.process_incoming_damage(damage_info)

func apply_effect(effect):
	effect.target.process_incoming_effect(effect)

func enter_combat():
	in_combat = true
	emit_signal("entered_combat")

func exit_combat():
	in_combat = false
	emit_signal("exited_combat")

func _on_monster_hp_updated():
	emit_signal("monster_hp_updated")

func _on_player_hp_updated():
	emit_signal("player_hp_updated")

func _on_monster_died():
	# TESTING
	LootManager.generate_test_loot()
	# /TESTING
	pass

func _on_monster_despawned():
	Monster = null
	exit_combat()
	emit_signal("next_combat_ready")

func _on_player_spawned(_player):
	Player = _player
	emit_signal("player_spawned")

func _on_monster_spawned(_monster):
	Monster = _monster
	emit_signal("monster_spawned")

func _on_zone_changed(_zone):
	Zone = _zone

func _on_monster_arrived():
	enter_combat()

func _on_effect_applied(effect):
	emit_signal("effect_applied", effect)

func enter_manual_combat():
	auto_combat = false
	emit_signal("entered_manual_combat")

func enter_auto_combat():
	auto_combat = true
	emit_signal("entered_auto_combat")

func _on_player_used_skill(skill):
	emit_signal("used_skill", skill)
	
func _on_manual_use_skill(skill):
	emit_signal("manual_use_skill", skill)

func _on_player_items_changed():
	emit_signal("items_changed")
