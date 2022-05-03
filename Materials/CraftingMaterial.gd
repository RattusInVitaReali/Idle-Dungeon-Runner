extends Slottable
class_name CraftingMaterial

var mat

var prefix
var special_weapon
var special_armor

var type
var weight
var tier
var durability

var quantity = 1

var stats = { "phys_damage": 0.0, "magic_damage": 0.0, "phys_protection": 0.0, "magic_protection": 0.0, 
					"max_hp": 0, "crit_chance": 0.0, "crit_multi": 0.0 }

func set_mat(_mat : MaterialResource):
	mat = _mat
	for property in get_script().get_script_property_list():
		if property.name in _mat:
			set(property.name, _mat.get(property.name))
	stats = _mat.stats.duplicate()
	return self

func quantity(quant):
	quantity = quant;
	return self

func print_material():
	print("Material : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	print("- Durability : %s" % durability)
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func same_as(_mat):
	return slottable_name == _mat.slottable_name and mat == _mat.mat and stats.hash() == _mat.stats.hash()

func add_quantity(amount):
	quantity += amount

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_outgoing_damage(damage_info, item)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_incoming_damage(damage_info, item)

func from_lootable(lootable):
	set_mat(lootable.material)
	quantity = lootable.min_quantity + randi() % (lootable.max_quantity - lootable.min_quantity + 1)
	return self
