extends Slottable
class_name ItemPart

export (CraftingProcessor.PART_TYPE) var type
export (int) var cost
export (int) var base_durability
export (float) var durability_multi

export (Array, CraftingProcessor.MATERIAL_TYPE) var allowed_material_types

export var stat_multipliers = { "phys_damage": 0.0, "magic_damage": 0.0, "phys_protection": 0.0, "magic_protection": 0.0, 
								"max_hp": 0.0, "crit_chance": 0.0, "crit_multi": 0.0 }

export var base_stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var part_name
var durability
var mat

func calculate_stats(mat : CraftingMaterial):
	for stat in mat.stats:
		stats[stat] = base_stats[stat] + mat.stats[stat] * stat_multipliers[stat]

func set_mat(mat : CraftingMaterial):
	if mat.type in allowed_material_types:
		add_child(mat)
		calculate_stats(mat)
		durability = base_durability + mat.durability * durability_multi
		set_part_name(mat)
		rarity = mat.rarity
		self.mat = mat
		return self
	return null

func set_part_name(mat : CraftingMaterial):
	part_name = mat.prefix + " " + CraftingProcessor.PART_TYPE.keys()[type].capitalize()

func print_part():
	print("Part : %s (%s)" % [part_name, CraftingProcessor.RARITY.keys()[rarity]])
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
