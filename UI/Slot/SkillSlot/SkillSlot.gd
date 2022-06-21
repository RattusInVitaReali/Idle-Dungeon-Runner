extends Slot

const SkillFrame = preload("res://_Resources/skill_borders/Border3.png")
const Lock = preload("res://_Resources/skill_icons/lock.png")

onready var skill_name = $NameBackground/Name

func set_slottable(_slottable):
	slottable = _slottable
	if _slottable != null:
		if !_slottable.locked:
			$Icon.texture_normal = slottable.icon
			skill_name.text = slottable.skill_name
		else:
			$Icon.texture_normal = Lock
			skill_name.text = "Locked"
		return
	$Icon.texture_normal = null
	skill_name.text = ""

func _on_Icon_pressed():
	if slottable != null:
		if !slottable.locked:
			inspector()
