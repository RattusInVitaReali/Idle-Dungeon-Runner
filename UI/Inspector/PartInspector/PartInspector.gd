extends Inspector

func test():
	var sword_blade = CraftingManager.SwordBlade.instance()
	sword_blade.test()
	set_slottable(sword_blade)
