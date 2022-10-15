extends Slottable
class_name CraftingMaterial

enum MATERIAL_TYPE { GEM, METAL, WOOD, FABRIC }

export (Resource) var mat

var prefix
var special_weapon
var special_armor

var type

var stats = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

func set_mat(_mat : MaterialResource, _tier = 0, _quantity = 1):
	mat = _mat
	for property in get_script().get_script_property_list():
		if property.name in mat:
			set(property.name, mat.get(property.name))
	set_tier(_tier)
	quantity = _quantity
	set_icon()
	return self

func set_tier(_tier):
	tier = _tier
	stats = mat.stats.duplicate()
	var i = tier
	while i > 0:
		for stat in stats:
			stats[stat] = 1.75 * stats[stat]
		i -= 1
	for stat in stats:
		stats[stat] = round(stats[stat])

func set_icon():
	icon = mat.get_icon()
	icon_color = mat.icon_color

func print_material():
	print("Material : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func same_as(_mat : Slottable):
	if _mat == null:
		return false
	return slottable_name == _mat.slottable_name and mat == _mat.mat and stats.hash() == _mat.stats.hash()

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_outgoing_damage(damage_info, item)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_incoming_damage(damage_info, item)

func on_outgoing_effect(effect : Effect, item):
	mat.on_outgoing_effect(effect, item)

func on_incoming_effect(effect : Effect, item):
	mat.on_incoming_effect(effect, item)

func from_lootable(lootable):
	set_mat(lootable.material)
	quantity = lootable.get_quantity()
	return self

func special_copy(new_material : CraftingMaterial):
	new_material.set_mat(mat, tier, quantity)

func tier_up():
	set_mat(mat, tier + 1, quantity)

func tier_down():
	if tier > 0:
		set_mat(mat, tier - 1, quantity)

func try_to_merge():
	if quantity < 5:
		return null
	var new_quantity = int(quantity / 5)
	var new_mat = duplicate()
	new_mat.set_mat(mat, tier + 1, new_quantity)
	quantity %= 5
	emit_signal("slottable_updated")
	return new_mat

func load():
	set_mat(mat, tier, quantity)
