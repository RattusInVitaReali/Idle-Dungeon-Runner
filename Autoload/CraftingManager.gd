extends Node

onready var Oak = load("res://Materials/Basic/Oak.tres")
onready var Copper = load("res://Materials/Basic/Copper.tres")
onready var Iron = load("res://Materials/Common/Iron.tres")
onready var Bloodsteel = load("res://Materials/Rare/Bloodsteel.tres")

onready var CraftingMaterial = load("res://Materials/CraftingMaterial.tscn")

onready var SwordBlade = load("res://ItemParts/SwordBlade/SwordBlade.tscn")
onready var SwordHandle = load("res://ItemParts/SwordHandle/SwordHandle.tscn")
onready var Pommel = load("res://ItemParts/Pommel/Pommel.tscn")

onready var Sword = load("res://Items/Sword/Sword.tscn")

onready var TestSwordBlade = load("res://ItemParts/SwordBlade/TestSwordBlade/TestSwordBlade.tscn")
onready var TestSword = load("res://Items/Sword/TestSword/TestSword.tscn")

enum RARITY { BASIC, COMMON, UNCOMMON, RARE, EPIC }

enum MATERIAL_TYPE { GEM, METAL, WOOD, FABRIC }
enum MATERIAL_WEIGHT { VERY_LIGHT, LIGHT, MEDIUM, HEAVY, VERY_HEAVY }

enum PART_TYPE { SWORD_BLADE, SWORD_HANDLE, POMMEL }

enum ITEM_TYPE { WEAPON, ARMOR, ANY }
enum ITEM_SUBTYPE { SWORD, AXE, BODY_ARMOR, BOOTS, HELMET } 

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
		var parent = parts[0].get_parent()
		for part in parts:
			parent.remove_child(part)
		new_item.create(parts)
		return new_item
	return null
