extends Control

const SkillStatLabel = preload("res://UI/SkillInspector/skill_stat_label.tscn")

#testing
const TestSkill = preload("res://skills/lacerate/lacerate.tscn")

var skill : Skill
var equipped = false

#testing
func _ready():
	skill = TestSkill.instance()
	update()

func update_tags():
	var tags = ""
	for tag in SkillData.skill_tags[skill.skill_name]:
		var p_tag = tag
		match tag:
			"phys":
				p_tag = "Physical"
			"cast_on_self": 
				p_tag = "Cast on Self"
			_:p_tag[0] = tag[0].to_upper()
		tags += p_tag + " - "
	tags.erase(tags.length() - 3, 3)
	$Panel/VBoxContainer/Tags.text = tags


func update_name_and_level():
	$Panel/VBoxContainer/Name.text = skill.skill_name
	$Panel/VBoxContainer/Implicit/Level.text = "Level " + str(skill.level)

func update_cooldown():
	$Panel/VBoxContainer/Implicit/Cooldown.text = "Cooldown: " + str(skill.base_cooldown) + "s"

func update_image():
	$Panel/VBoxContainer/Image/Border/Icon.texture = load(skill.icon_path)

func update_desc():
	$Panel/VBoxContainer/Stats/Description/Description.text = SkillData.skill_desc[skill.skill_name]

func update_button():
	if (equipped):
		$Panel/VBoxContainer/HBoxContainer/Equip/Label.text = "UNEQUIP"

func update():
	if skill != null:
		update_name_and_level()
		update_cooldown()
		update_tags()
		update_desc()
		update_button()
		update_image()
	else:
		print("skill is null")

func _on_TextureButton_pressed():
	queue_free()


func _on_Equip_pressed():
	if (not equipped):
		SkillData.init_skill(skill.skill_name)
