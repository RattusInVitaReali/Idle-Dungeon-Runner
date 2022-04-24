extends Item

# Makes a sword
func test():
	var oak = CraftingManager.new_material(CraftingManager.Oak)
	var iron = CraftingManager.new_material(CraftingManager.Iron)
	var bloodsteel = CraftingManager.new_material(CraftingManager.Bloodsteel)
	
	var sword_blade = CraftingManager.new_part(CraftingManager.SwordBlade, bloodsteel)
	var sword_handle = CraftingManager.new_part(CraftingManager.SwordHandle, oak)
	var pommel = CraftingManager.new_part(CraftingManager.Pommel, iron)
	
	create([
		sword_blade,
		sword_handle
	])
	add_part(
		pommel
	)
