extends TextureRect
class_name EffectIcon

const BorderPositive = preload("res://RESOURCES/SkillBorders/Border5.png")
const BorderNegative = preload("res://RESOURCES/SkillBorders/Border2.png")

var effect
var duration

var valid = true

func _process(delta):
	$TimeProgress.value = (effect.get_duration_timer().time_left / duration) * 100

func initialize(_effect):
	effect = _effect
	if effect.target.dead:
		expire()
	effect.connect("effect_expired", self, "expire")
	effect.connect("effect_updated", self, "update_effect")
	update_effect()

func update_effect():
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
