extends Slot

const SkillFrame = preload("res://_Resources/skill_borders/Border3.png")
const Lock = preload("res://_Resources/skill_icons/lock.png")

onready var skill_name = $NameBackground/Name

func set_slottable(_slottable):
	slottable = _slottable
	if _slottable == null:
		$Icon.texture_normal = null
		skill_name.text = ""
	else:
		$Icon.texture_normal = slottable.icon
		skill_name.text = slottable.skill_name
