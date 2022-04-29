extends Node

onready var Oak = load("res://Materials/Basic/Oak.tres")
onready var Iron = load("res://Materials/Basic/Iron.tres")
onready var Bloodsteel = load("res://Materials/Rare/Bloodsteel.tres")

onready var CraftingMaterial = load("res://Materials/CraftingMaterial.tscn")

onready var SwordBlade = load("res://ItemParts/SwordBlade/SwordBlade.tscn")
onready var SwordHandle = load("res://ItemParts/SwordHandle/SwordHandle.tscn")
onready var Pommel = load("res://ItemParts/Pommel/Pommel.tscn")

onready var Sword = load("res://Items/Sword/Sword.tscn")


enum RARITY { BASIC, COMMON, UNCOMMON, RARE, EPIC }

enum MATERIAL_TYPE { GEM, METAL, WOOD, FABRIC }
enum MATERIAL_WEIGHT { VERY_LIGHT, LIGHT, MEDIUM, HEAVY, VERY_HEAVY }

enum PART_TYPE { SWORD_BLADE, SWORD_HANDLE, POMMEL }

enum ITEM_TYPE { WEAPON, ARMOR, ANY }
enum ITEM_SUBTYPE { SWORD, AXE, BODY_ARMOR, BOOTS, HELMET } 

func new_material(base = null):
	return CraftingMaterial.instance().set_mat(base)

func new_part(part, material):
	return part.instance().set_mat(material)