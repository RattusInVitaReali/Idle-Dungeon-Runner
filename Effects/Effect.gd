extends Node2D
class_name Effect

signal effect_expired

export (Texture) var icon
export var base_duration = 0.0
export var base_tick_duration = 0.0
export var tick_based = true

var duration = 0.0
var tick_duration = 0.0
var attacker = null
var target = null


func initialize(_attacker, _target):
	attacker = _attacker
	target = _target
	attacker.connect("died", self, "expire")
	target.connect("died", self, "_on_EffectTime_timeout")
	return self

func duration(_duration):
	duration = _duration
	$EffectTime.wait_time = duration
	return self

func tick_duration(_tick_duration):
	tick_duration = _tick_duration
	$TickTime.wait_time = tick_duration
	return self

func get_duration_timer():
	return $EffectTime

func begin():
	$EffectTime.start()
	do_at_start()
	if tick_based:
		$TickTime.start()

func tick():
	pass

func do_at_start():
	pass

func do_at_end():
	pass

func expire():
	emit_signal("effect_expired")
	queue_free()

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func _on_EffectTime_timeout():
	do_at_end()
	$EffectTime.stop()
	$TickTime.stop()
	expire()

func _on_TickTime_timeout():
	tick()
