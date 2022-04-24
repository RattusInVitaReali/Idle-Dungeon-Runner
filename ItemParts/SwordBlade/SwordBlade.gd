extends ItemPart

# Makes a Sword Blade
func test():
	var bloodsteel = CraftingManager.new_material(CraftingManager.Bloodsteel)
	set_mat(bloodsteel)
	
