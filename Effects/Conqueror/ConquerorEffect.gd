extends Effect
class_name ConquerorEffect

const multi_per_stack = 0.005

var stacks = 1

func initialize(attacker, target):
	.initialize(attacker, target)
	connect("effect_updated", attacker, "update_stats")
	return self

func add_stack():
	stacks += 1
	
	duration(base_duration)
	emit_signal("effect_updated")

func get_value():
	return str(stacks)

func process_duration_multi(dm):
	return

func process_strength_multi(sm): 
	return

func apply_attributes(attributes):
	attributes["power"] *= 1 + stacks * multi_per_stack

func _on_exited_combat():
	._on_exited_combat()
	expire()
