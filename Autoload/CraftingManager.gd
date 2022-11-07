extends Node
class_name CraftingManagerScript

var debug = false

enum RARITY { BASIC, COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

enum MATERIAL_TYPE { GEM, METAL, WOOD, FABRIC, LEATHER }

enum PART_TYPE { SWORD_BLADE, SWORD_HANDLE, SWORD_GUARD, POMMEL,
				 TUNIC, CHESTPLATE, SHOULDERS, ARMS,
				 AXE_HEAD, AXE_HANDLE, SECONDARY_AXE_HEAD,
				 CHAIN, CROWN, FOCUS,
				 RING_BAND, RING_BEADS,
				 HELMET_LINING, HELMET_PROTECTION, ORNAMENT, VISOR, NECKGUARD,
				 BOOT_LINING, BOOT_PROTECTION, CALFGUARDS, BOOT_COLLARS,
				 PANTS_LINING, SIDEGUARDS, SHINGUARDS, KNEEPADS, OVERPANTS,
				 GLOVE_LINING, HAND_PROTECTION, FOREARM_PROTECTION }

enum ITEM_TYPE { WEAPON, ARMOR, ACCESSORY, ANY }
enum ITEM_SUBTYPE { SWORD, AXE, BODY_ARMOR, BOOTS, HELMET, PANTS, WRIST, GLOVES, RING, AMULET } 

onready var CraftingMaterial = load("res://Materials/CraftingMaterial.tscn")

onready var part_scenes = {
	PART_TYPE.SWORD_BLADE : load("res://ItemParts/Weapon/SWORD/SwordBlade/SwordBlade.tscn"),
	PART_TYPE.SWORD_HANDLE : load("res://ItemParts/Weapon/SWORD/SwordHandle/SwordHandle.tscn"),
	PART_TYPE.SWORD_GUARD : load("res://ItemParts/Weapon/SWORD/SwordGuard/SwordGuard.tscn"),
	PART_TYPE.POMMEL : load("res://ItemParts/Weapon/Pommel/Pommel.tscn"),
	
	PART_TYPE.AXE_HEAD : load("res://ItemParts/Weapon/AXE/AxeHead/AxeHead.tscn"),
	PART_TYPE.AXE_HANDLE : load("res://ItemParts/Weapon/AXE/AxeHandle/AxeHandle.tscn"),
	PART_TYPE.SECONDARY_AXE_HEAD : load("res://ItemParts/Weapon/AXE/AxeSecondaryHead/AxeSecondaryHead.tscn"),
	
	PART_TYPE.TUNIC : load("res://ItemParts/Armor/BODYARMOR/Tunic/Tunic.tscn"),
	PART_TYPE.CHESTPLATE : load("res://ItemParts/Armor/BODYARMOR/Chestplate/Chestplate.tscn"),
	PART_TYPE.SHOULDERS : load("res://ItemParts/Armor/BODYARMOR/Shoulders/Shoulders.tscn"),
	PART_TYPE.ARMS : load("res://ItemParts/Armor/BODYARMOR/Arms/Arms.tscn"), 
	
	PART_TYPE.PANTS_LINING : load("res://ItemParts/Armor/PANTS/PantsLining/PantsLining.tscn"),
	PART_TYPE.SIDEGUARDS : load("res://ItemParts/Armor/PANTS/Sideguards/Sideguards.tscn"), 
	PART_TYPE.SHINGUARDS : load("res://ItemParts/Armor/PANTS/Shinguards/Shinguards.tscn"), 
	PART_TYPE.KNEEPADS : load("res://ItemParts/Armor/PANTS/Kneepads/Kneepads.tscn"),
	PART_TYPE.OVERPANTS : load("res://ItemParts/Armor/PANTS/Overpants/Overpants.tscn"),
	
	PART_TYPE.HELMET_LINING : load("res://ItemParts/Armor/HELMET/HelmetLining/HelmetLining.tscn"),
	PART_TYPE.HELMET_PROTECTION : load("res://ItemParts/Armor/HELMET/HelmetProtection/HelmetProtection.tscn"), 
	PART_TYPE.ORNAMENT : load("res://ItemParts/Armor/HELMET/Ornament/Ornament.tscn"), 
	PART_TYPE.VISOR : load("res://ItemParts/Armor/HELMET/Visor/Visor.tscn"), 
	PART_TYPE.NECKGUARD : load("res://ItemParts/Armor/HELMET/Neckguard/Neckguard.tscn"),
	
	PART_TYPE.BOOT_LINING : load("res://ItemParts/Armor/BOOTS/BootLining/BootLining.tscn"),
	PART_TYPE.BOOT_PROTECTION : load("res://ItemParts/Armor/BOOTS/BootProtection/BootProtection.tscn"),
	PART_TYPE.CALFGUARDS : load("res://ItemParts/Armor/BOOTS/Calfguards/Calfguards.tscn"),
	PART_TYPE.BOOT_COLLARS : load("res://ItemParts/Armor/BOOTS/BootCollars/BootCollars.tscn"),
	
	PART_TYPE.GLOVE_LINING : load("res://ItemParts/Armor/GLOVES/GloveLining/GloveLining.tscn"), 
	PART_TYPE.HAND_PROTECTION : load("res://ItemParts/Armor/GLOVES/HandProtection/HandProtection.tscn"), 
	PART_TYPE.FOREARM_PROTECTION : load("res://ItemParts/Armor/GLOVES/ForearmProtection/ForearmProtection.tscn"), 
	
	PART_TYPE.CHAIN : load("res://ItemParts/Accessory/AMULET/Chain/Chain.tscn"), 
	PART_TYPE.FOCUS : load("res://ItemParts/Accessory/Focus/Focus.tscn"), 
	PART_TYPE.CROWN : load("res://ItemParts/Accessory/Crown/Crown.tscn"), 
	
	PART_TYPE.RING_BAND : load("res://ItemParts/Accessory/RING/RingBand/RingBand.tscn"), 
	PART_TYPE.RING_BEADS : load("res://ItemParts/Accessory/RING/RingBeads/RingBeads.tscn")
}

onready var item_scenes = {
	ITEM_SUBTYPE.SWORD : load("res://Items/Weapon/Sword/Sword.tscn"),
	ITEM_SUBTYPE.AXE : load("res://Items/Weapon/Axe/Axe.tscn"),
	ITEM_SUBTYPE.BODY_ARMOR : load("res://Items/Armor/BodyArmor/BodyArmor.tscn"),
	ITEM_SUBTYPE.PANTS : load("res://Items/Armor/Pants/Pants.tscn"),
	ITEM_SUBTYPE.HELMET : load("res://Items/Armor/Helmet/Helmet.tscn"),
	ITEM_SUBTYPE.BOOTS : load("res://Items/Armor/Boots/Boots.tscn"),
	ITEM_SUBTYPE.GLOVES : load("res://Items/Armor/Gloves/Gloves.tscn"),
	ITEM_SUBTYPE.AMULET : load("res://Items/Accessory/Amulet/Amulet.tscn"),
	ITEM_SUBTYPE.RING : load("res://Items/Accessory/Ring/Ring.tscn")
}

func try_to_forge_part(part, material):
	if part.can_use_material(material):
		var new_mat = material.split(0)
		if new_mat == null:
			return null
		var new_part = part.duplicate()
		new_part.set_mat(new_mat)
		return new_part
	return null

func actually_forge_part(part, material):
	var new_mat = material.split(part.cost)
	if new_mat == null:
		return null
	var new_part = part.duplicate()
	new_part.set_mat(new_mat)
	return new_part

func forge_item(item, parts):
	if item.can_create(parts):
		var new_item = item.duplicate()
		var new_parts = []
		for req_part in item.required_parts:
			for part in parts:
				if part.type == req_part:
					new_parts.append(part.split(1))
					break
		for opt_part in item.optional_parts:
			for part in parts:
				if part.type == opt_part:
					new_parts.append(part.split(1))
					break
		new_item.create(new_parts)
		return new_item
	return null
