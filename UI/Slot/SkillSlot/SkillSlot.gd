extends Slot

const BorderTexture1 = preload("res://_Resources/skill_borders/Border3.png")
const BorderTexture2 = preload("res://_Resources/skill_borders/Border4.png")
const BorderTexture3 = preload("res://_Resources/skill_borders/Border5.png")
const BorderTexture4 = preload("res://_Resources/skill_borders/Border6.png")
const SkillFrame = preload("res://_Resources/skill_borders/Border3.png")
const Lock = preload("res://_Resources/skill_icons/lock.png")

onready var skill_name = $NameBackground/Name

func set_slottable(_slottable):
	slottable = _slottable
	if slottable != null:
		slottable.connect("skill_updated", self, "update_skill")
	update_skill()

func set_border():
	if slottable == null:
		texture = BorderTexture1
	elif slottable.level <= 5:
		texture = BorderTexture1
	elif slottable.level <= 10:
		texture = BorderTexture2
	elif slottable.level <= 15:
		texture = BorderTexture3
	else:
		texture = BorderTexture4

func set_icon():
	if slottable == null:
		$Icon.texture_normal = null
		skill_name.text = ""
	elif !slottable.locked:
		$Icon.texture_normal = slottable.icon
		skill_name.text = slottable.skill_name
	else:
		$Icon.texture_normal = Lock
		skill_name.text = "Locked"

func update_skill():
	set_border()
	set_icon()

func _on_Icon_pressed():
	if slottable != null:
		if !slottable.locked:
			inspector()
