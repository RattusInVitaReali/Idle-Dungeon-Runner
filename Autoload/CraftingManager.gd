extends Node

var debug = true

enum RARITY { BASIC, COMMON, UNCOMMON, RARE, EPIC }

enum MATERIAL_TYPE { GEM, METAL, WOOD, FABRIC, LEATHER }
enum MATERIAL_WEIGHT { VERY_LIGHT, LIGHT, MEDIUM, HEAVY, VERY_HEAVY }

enum PART_TYPE { SWORD_BLADE, SWORD_HANDLE, SWORD_GUARD, POMMEL, TUNIC, CHESTPLATE, SHOULDERS, ARMS, AXE_HEAD, AXE_HANDLE, AXE_SECONDARY_HEAD }

enum ITEM_TYPE { WEAPON, ARMOR, ANY }
enum ITEM_SUBTYPE { SWORD, AXE, BODY_ARMOR, BOOTS, HELMET } 

onready var CraftingMaterial = load("res://Materials/CraftingMaterial.tscn")

onready var part_scenes = {
	PART_TYPE.SWORD_BLADE : load("res://ItemParts/Weapon/_Sword/SwordBlade/SwordBlade.tscn"),
	PART_TYPE.SWORD_HANDLE : load("res://ItemParts/Weapon/_Sword/SwordHandle/SwordHandle.tscn"),
	PART_TYPE.SWORD_GUARD : load("res://ItemParts/Weapon/_Sword/SwordGuard/SwordGuard.tscn"),
	PART_TYPE.POMMEL : load("res://ItemParts/Weapon/Pommel/Pommel.tscn"),
	PART_TYPE.AXE_HEAD : load("res://ItemParts/Weapon/_Axe/AxeHead/AxeHead.tscn"),
	PART_TYPE.AXE_HANDLE : load("res://ItemParts/Weapon/_Axe/AxeHandle/AxeHandle.tscn"),
	PART_TYPE.AXE_SECONDARY_HEAD : load("res://ItemParts/Weapon/_Axe/AxeSecondaryHead/AxeSecondaryHead.tscn"),
	PART_TYPE.TUNIC : load("res://ItemParts/Armor/_BodyArmor/Tunic/Tunic.tscn"),
	PART_TYPE.CHESTPLATE : load("res://ItemParts/Armor/_BodyArmor/Chestplate/Chestplate.tscn"),
	PART_TYPE.SHOULDERS : load("res://ItemParts/Armor/_BodyArmor/Shoulders/Shoulders.tscn"),
	PART_TYPE.ARMS : load("res://ItemParts/Armor/_BodyArmor/Arms/Arms.tscn")
}

onready var item_scenes = {
	ITEM_SUBTYPE.SWORD : load("res://Items/Weapon/Sword/Sword.tscn"),
	ITEM_SUBTYPE.AXE : load("res://Items/Weapon/Axe/Axe.tscn"),
	ITEM_SUBTYPE.BODY_ARMOR : load("res://Items/Armor/BodyArmor/BodyArmor.tscn")
}

func new_material(base = null, quantity = 1):
	return CraftingMaterial.instance().set_mat(base).quantity(quantity)

func new_part(part, material):
	return part.instance().set_mat(material)

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
