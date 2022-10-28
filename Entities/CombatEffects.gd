extends AnimatedSprite
class_name CombatEffects

const anim_wait = 0.1

func play_on_hit(damage_info : CombatProcessor.DamageInfo):
	yield(get_tree().create_timer(anim_wait), "timeout")
	if Random.rng.randf_range(0, 1) < 0.75:
		flip_h = !flip_h
	frame = 0
	self_modulate = damage_info.color
	show()
	play("blood_3")

func _on_CombatEffects_animation_finished():
	hide()
