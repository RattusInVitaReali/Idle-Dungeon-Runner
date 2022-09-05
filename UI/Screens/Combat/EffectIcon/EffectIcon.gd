extends TextureRect
class_name EffectIcon

const BorderPositive = preload("res://_Resources/skill_borders/Border5.png")
const BorderNegative = preload("res://_Resources/skill_borders/Border2.png")

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
	if effect.negative:
		texture = BorderNegative
	else:
		texture = BorderPositive
	$TextureRect.texture = effect.icon
	$Value.text = effect.get_value()
	duration = effect.duration

func expire():
	set_process(false)
	queue_free()
