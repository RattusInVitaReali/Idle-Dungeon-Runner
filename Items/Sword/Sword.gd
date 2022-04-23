extends Item

# Makes a sword
func test():
	var Oak = load("res://Materials/Basic/Oak.tscn")
	var Iron = load("res://Materials/Basic/Iron.tscn")
	var Bloodsteel = load("res://Materials/Rare/Bloodsteel.tscn")
	var SwordBlade = load("res://ItemParts/SwordBlade/SwordBlade.tscn")
	var SwordHandle = load("res://ItemParts/SwordHandle/SwordHandle.tscn")
	var Pommel = load("res://ItemParts/Pommel/Pommel.tscn")
	
	var oak = Oak.instance()
	var iron1 = Iron.instance()
	var iron2 = Iron.instance()
	var iron3 = Iron.instance()
	var bloodsteel = Bloodsteel.instance()
	
	var sword_blade = SwordBlade.instance().set_mat(bloodsteel)
	var sword_handle = SwordHandle.instance().set_mat(oak)
	var pommel = Pommel.instance().set_mat(iron2)
	
	create([
		sword_blade,
		sword_handle
	])
	add_part(
		pommel
	)
