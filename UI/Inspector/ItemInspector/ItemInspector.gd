extends Inspector

onready var parts = $Panel/VBoxContainer/Parts

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_parts()

func update_parts():
	var p = ""
	for part in slottable.get_parts():
		p += part.slottable_name
		p += " - "
	p.erase(p.length() - 3, 3)
	parts.text = p

func test():
	var sword = CraftingManager.Sword.instance()
	sword.test()
	set_slottable(sword)
