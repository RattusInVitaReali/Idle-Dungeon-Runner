extends Slottable
class_name Item

export (Texture) var base_icon

export (Array, CraftingManager.PART_TYPE) var required_parts
export (Array, CraftingManager.PART_TYPE) var optional_parts
export (CraftingManager.ITEM_TYPE) var type
export (CraftingManager.ITEM_SUBTYPE) var subtype

export (int) var base_durability
export (float) var durability_multi

export (String) var description

export var base_stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var durability

var special = ""
var custom_name = ""

func _ready():
	icon = base_icon

func can_create(parts : Array):
	for req_part_type in required_parts:
		var found = false
		for part in parts:
			if part.type == req_part_type:
				found = true
				break
		if !found:
			return false
	return true

func create(parts : Array):
	if can_create(parts):
		for part in parts:
			add_part(part)
		icon = base_icon # Temp
		return true
	return false

func get_parts():
	return get_children()

func add_part(part):
	for child_part in get_children():
		if part.type == child_part.type:
			return false
	add_child(part)
	update_rarity(part)
	set_slottable_name()
	calculate_stats()
	calculate_durability()
	update_special()

func update_rarity(part):
	rarity = max(rarity, part.rarity)

func custom_name(_name):
	custom_name = _name
	set_slottable_name()

func set_slottable_name():
	if custom_name != "":
		slottable_name = custom_name
	else:
		var new_name = ""
		for part_type in required_parts:
			for child in get_children():
				if child.type == part_type:
					if !(child.mat.prefix in new_name):
						new_name += child.mat.prefix + "-"
					break
		new_name.erase(new_name.length() - 1, 1)
		new_name += " "
		new_name += CraftingManager.ITEM_SUBTYPE.keys()[subtype].capitalize()
		slottable_name = new_name

func calculate_stats():
	for stat in stats:
		stats[stat] = base_stats[stat]
	for child_part in get_children():
		for stat in child_part.stats:
			stats[stat] += child_part.stats[stat]

func calculate_durability():
	durability = 0
	for part in get_children():
		durability += part.durability

func update_special():
	special = ""
	for part in get_children():
		if special != "":
			special += '\n'
		special += part.special

func apply_stats(_stats):
	for stat in stats:
		_stats[stat] += stats[stat]

func print_item():
	print("Item : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	print("- Durability : %s" % durability)
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func on_outgoing_damage(damage_info : CombatProcessor.DamageInfo):
	for part in get_children():
		part.on_outgoing_damage(damage_info, self)

func on_incoming_damage(damage_info : CombatProcessor.DamageInfo):
	for part in get_children():
		part.on_incoming_damage(damage_info, self)

func from_lootable(lootable):
	var _parts = []
	for part in lootable.parts:
		_parts.append(part.get_loot()) # Making use of ItemPartLootable.get_loot()
	create(_parts)
	custom_name(lootable.custom_name)
	return self
