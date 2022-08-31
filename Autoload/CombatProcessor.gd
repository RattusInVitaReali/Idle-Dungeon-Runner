extends Node
class_name CombatProcessorScript

var Bleeding = load("res://Effects/Bleeding/Bleeding.tscn")
var Decimated = load("res://Effects/Decimated/Decimated.tscn")

signal entered_combat
signal exited_combat

signal entered_auto_combat
signal entered_manual_combat

signal breakthrough_updated

signal monster_spawned
signal monster_died

signal player_spawned
signal player_despawned

signal zone_changed
signal quest_changed


var Monster
var Player

var in_combat = false

var auto_combat = true

var breakthrough = true setget set_breakthrough

class DamageInfo:
	
	var attacker = null
	var target = null
	var phys_damage = 0
	var magic_damage = 0
	var phys_pen = 0
	var magic_pen = 0
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

	func phys_pen(_phys_pen):
		phys_pen = _phys_pen
		return self

	func magic_pen(_magic_pen):
		magic_pen = _magic_pen
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

func monster_spawned(_monster):
	Monster = _monster
	emit_signal("monster_spawned", Monster)

func monster_died(monster, zone):
	emit_signal("monster_died", monster, zone)

func monster_despawned():
	Monster = null
	exit_combat()

func player_spawned(_player):
	Player = _player
	emit_signal("player_spawned", Player)

func player_despawned():
	exit_combat()
	emit_signal("player_despawned")

func enter_manual_combat():
	auto_combat = false
	emit_signal("entered_manual_combat")

func enter_auto_combat():
	auto_combat = true
	emit_signal("entered_auto_combat")

func change_zone(zone):
	emit_signal("zone_changed", zone)

func change_quest(quest):
	emit_signal("quest_changed", quest)

func set_breakthrough(br):
	breakthrough = br
	emit_signal("breakthrough_updated")
