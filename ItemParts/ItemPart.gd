extends Slottable
class_name ItemPart

const CraftingMaterial = preload("res://Materials/CraftingMaterial.tscn")

export (Texture) var base_icon
export (Texture) var item_icon

export (CraftingManager.PART_TYPE) var type
export (CraftingManager.ITEM_TYPE) var used_for
export (int) var cost

export (Array, CraftingManager.MATERIAL_TYPE) var allowed_material_types
export (String) var description

export var stat_multipliers = {
	"power": 0.0, 
	"potency": 0.0, 
	"dexterity": 0.0, 
	"precision": 0.0, 
	"ferocity": 0.0, 
	"mastery": 0.0, 
	"expertise": 0.0, 
	"armor": 0.0, 
	"occult_aversion": 0.0, 
	"vitality": 0.0, 
	"toughess": 0.0, 
	"penetration": 0.0, 
	"magic_penetration": 0.0, 
}

export var base_stats = {
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

var stats = base_stats.duplicate()

var mat : CraftingMaterial
var special = ""

func _ready():
	icon = base_icon

func can_use_material(_mat : CraftingMaterial):
	return _mat.type in allowed_material_types and _mat.quantity >= cost

func set_mat(_mat : CraftingMaterial):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	if _mat.type in allowed_material_types:
		mat = _mat
		add_child(mat)
		calculate_stats()
		set_slottable_name()
		set_special()
		tier = mat.tier
		rarity = mat.rarity
		icon = base_icon
		icon_color = mat.icon_color
		return self
	return null

func calculate_stats():
	for stat in mat.stats:
		stats[stat] = base_stats[stat] + round(mat.stats[stat] * stat_multipliers[stat])

func set_slottable_name():
	slottable_name = mat.prefix + " " + CraftingManager.PART_TYPE.keys()[type].capitalize()

func set_special():
	match used_for:
		CraftingManager.ITEM_TYPE.WEAPON:
			special = mat.special_weapon
		CraftingManager.ITEM_TYPE.ARMOR:
			special = mat.special_armor
		CraftingManager.ITEM_TYPE.ANY:
			special = "Weapon: " + mat.special_weapon + "Armor: " + mat.special_armor

func print_part():
	print("Part : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func get_part_icon():
	return icon

func get_item_icon(item):
	return item_icon

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_outgoing_damage(damage_info, item)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo, item):
	mat.on_incoming_damage(damage_info, item)

func on_outgoing_effect(effect : Effect, item):
	mat.on_outgoing_effect(effect, item)

func on_incoming_effect(effect : Effect, item):
	mat.on_incoming_effect(effect, item)

func from_lootable(lootable):
	var _mat = CraftingMaterial.instance().set_mat(lootable.material, lootable.tier, cost)
	set_mat(_mat)
	return self

func special_copy(new_slottable):
	mat.quantity += 1
	var new_mat = mat.split(1)
	new_slottable.set_mat(new_mat)

func same_as(item_part : Slottable):
	if item_part.slottable_type != SLOTTABLE_TYPE.ITEM_PART:
		return false
	if item_part == null:
		return false
	if mat == null or item_part.mat == null:
		return false
	return mat.same_as(item_part.mat) and tier == item_part.tier and type == item_part.type

func try_to_merge():
	if quantity < 5:
		return null
	var new_quantity = int(quantity / 5)
	var new_part = duplicate()
	mat.quantity += 5
	var new_mat = mat.split(5)
	new_mat = new_mat.try_to_merge()
	new_mat.quantity = cost
	new_part.set_mat(new_mat)
	new_part.quantity = new_quantity
	self.quantity %= 5
	emit_signal("slottable_updated")
	return new_part

func tier_up():
	remove_child(mat)
	mat.set_mat(mat.mat, mat.tier + 1)
	set_mat(mat)

func tier_down():
	if mat.tier > 0:
		remove_child(mat)
		mat.set_mat(mat.mat, mat.tier - 1)
		set_mat(mat)

func dismantle(var parent_quantity = 1):
	remove_child(mat)
	mat.quantity = cost # "TemProARy" fix for stupid ass dismantling previously equipped items bug 
	mat.quantity = int(mat.quantity / 4) * parent_quantity * max(1, quantity)
	mat.quantity *= pow(5, mat.tier)
	mat.set_mat(mat.mat, 0, mat.quantity)
	LootManager.get_item(mat)
	print("Got " + str(mat.quantity) + " mats")
	queue_free()

func load():
	for child in get_children():
		remove_child(child)
		child.load()
		set_mat(child)
