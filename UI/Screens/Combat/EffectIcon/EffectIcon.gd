extends TextureRect
class_name EffectIcon

var effect
var duration

var valid = true

func _process(delta):
	$TimeProgress.value = (effect.get_duration_timer().time_left / duration) * 100

func initialize(_effect):
	if _effect.target.dead:
		expire()
	effect = _effect
	effect.connect("effect_expired", self, "expire")
	$TextureRect.texture = effect.icon
	duration = effect.duration

func expire():
	set_process(false)
	queue_free()
