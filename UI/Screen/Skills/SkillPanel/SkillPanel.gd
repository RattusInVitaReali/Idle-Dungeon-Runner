extends Panel

var skill_name : String
const tags_dict = {"phys": "res://resources/icons2/image_part_091.png",
				 "magic": "res://resources/icons2/image_part_009.png",
				 "attack": "res://resources/icons2/image_part_051.png",
				 "cast_on_self": "res://resources/icons2/image_part_033.png"}

onready var tags_group = [$HBoxContainer/VBoxContainer/Tags1/Tag1, $HBoxContainer/VBoxContainer/Tags1/Tag2, $HBoxContainer/VBoxContainer/Tags1/Tag3,
						 $HBoxContainer/VBoxContainer/Tags2/Tag4, $HBoxContainer/VBoxContainer/Tags2/Tag5, $HBoxContainer/VBoxContainer/Tags2/Tag6]


func initialize(_skill_name):
	skill_name = _skill_name
	$HBoxContainer/Skill/SkillIcon.texture_normal = load(SkillData.skill_textures[skill_name])
	$HBoxContainer/VBoxContainer/Level.text = "Level " + str(SkillData.skills[skill_name]["level"])
	$HBoxContainer/NameAndLevel/Name.text = skill_name
	update_exp_bar()
	update_tags()


func update_exp_bar():
	var data = SkillData.get_skill_ui_exp(skill_name)
	$HBoxContainer/NameAndLevel/TextureProgress/ExperienceText.text = str(data[0]) + " / " + str(data[1])
	$HBoxContainer/NameAndLevel/TextureProgress.value = data[0] / data[1] * 100


func update():
	if skill_name != null:
		$HBoxContainer/VBoxContainer/Level.text = "Level " + str(SkillData.skills[skill_name]["level"])
		$HBoxContainer/NameAndLevel/Name.text = skill_name
		update_exp_bar()


func update_tags():
	clear_tags()
	for tag in SkillData.skill_tags[skill_name]:
		for tag_node in tags_group:
			if tag_node.texture == null:
				tag_node.texture = load(tags_dict[tag])
				break


func clear_tags():
	for tag_node in tags_group:
		tag_node.texture = null
