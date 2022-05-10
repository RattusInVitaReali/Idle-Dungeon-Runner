extends Slottable
class_name ItemPart

const CraftingMaterial = preload("res://Materials/CraftingMaterial.tscn")

export (Texture) var base_icon

export (CraftingManager.PART_TYPE) var type
export (CraftingManager.ITEM_TYPE) var used_for
export (int) var cost
export (int) var base_durability
export (float) var durability_multi

export (Array, CraftingManager.MATERIAL_TYPE) var allowed_material_types

export var stat_multipliers = { "phys_damage": 0.0, "magic_damage": 0.0, "phys_protection": 0.0, "magic_protection": 0.0, 
								"max_hp": 0.0, "crit_chance": 0.0, "crit_multi": 0.0 }

export var base_stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

export (String) var description

var durability
var mat
var special = ""

func _ready():
	# Temp
	icon = base_icon

func can_use_material(mat : CraftingMaterial):
	return mat.type in allowed_material_types and mat.quantity >= cost

func set_mat(_mat : CraftingMaterial):
	if _mat.type in allowed_material_types:
		mat = _mat
		add_child(mat)
		calculate_stats()
		calculate_durability()
		set_slottable_name()
		set_special()
		rarity = mat.rarity
		icon = base_icon # Temp
		return self
	return null

func calculate_stats():
	for stat in mat.stats:
		stats[stat] = base_stats[stat] + mat.stats[stat] * stat_multipliers[stat]

func calculate_durability():
	durability = base_durability + mat.durability * durability_multi

func set_slottable_name():
	slottable_name = mat.prefix + " " + CraftingManager.PART_TYPE.keys()[type].capitalize()

func set_special():
	match used_for:
		CraftingManager.ITEM_TYPE.WEAPON:
			special = mat.special_weapon
		CraftingManager.TYPE.ARMOR:
			special = mat.special_armor
		CraftingManager.ITEM_TYPE.ANY:
			special = "Weapon: " + mat.special_weapon + "Armor: " + mat.special_armor

func print_part():
	print("Part : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	print("- Durability : %s" % durability)
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	for mat in get_children():
		mat.on_outgoing_damage(damage_info, item)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	for mat in get_children():
		mat.on_incoming_damage(damage_info, item)

func from_lootable(lootable):
	var mat = CraftingMaterial.instance().set_mat(lootable.material)
	set_mat(mat)
	return self
