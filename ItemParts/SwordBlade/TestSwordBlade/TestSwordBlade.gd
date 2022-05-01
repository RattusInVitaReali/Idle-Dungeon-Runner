extends SwordBlade

func _ready():
	test()

func test():
	var iron = CraftingManager.new_material(CraftingManager.Iron)
	set_mat(iron)
