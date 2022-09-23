extends Node2D
class_name Effect

const IconPositive = preload("res://RESOURCES/Effects/BaseNegative.png")
const IconNegative = preload("res://RESOURCES/Effects/BasePositive.png")

signal effect_expired
# warning-ignore:unused_signal
signal effect_updated

export (Texture) var icon
export (String) var effect_name
export var base_duration = 0.0
export var base_tick_duration = 0.0
export var tick_based = true
export var negative = true

var expired = false

var duration = 0.0
var tick_duration = 0.0
var attacker = null
var target = null

var is_crit = false

func initialize(_attacker, _target):
	attacker = _attacker
	target = _target
	attacker.connect("tree_exiting", self, "expire")
	attacker.connect("died", self, "expire")
	if target != attacker:
		target.connect("tree_exiting", self, "expire")
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
	
func icon(_icon):
	icon = _icon
	return self

func process_duration_multi(dm):
	duration(duration * dm)

func process_strength_multi(sm):
	pass

func get_duration_timer():
	return $EffectTime

func get_value():
	pass

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
	expired = true
	emit_signal("effect_expired")
	queue_free()

func apply_crit():
	is_crit = true

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	pass

func apply_attributes(attributes):
	pass

func _on_EffectTime_timeout():
	do_at_end()
	$EffectTime.stop()
	$TickTime.stop()
	expire()

func _on_TickTime_timeout():
	tick()
