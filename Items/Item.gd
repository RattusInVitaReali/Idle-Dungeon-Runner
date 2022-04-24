extends Slottable
class_name Item

export (Texture) var base_icon

export (Array, CraftingManager.PART_TYPE) var required_parts
export (Array, CraftingManager.PART_TYPE) var optional_parts
export (CraftingManager.ITEM_TYPE) var type
export (CraftingManager.ITEM_SUBTYPE) var subtype

export (int) var base_durability
export (float) var durability_multi

export var base_stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var stats = { "max_hp": 0, "phys_damage": 0, "magic_damage": 0, "phys_protection": 0, "magic_protection": 0, "crit_chance": 0.0,
			 "crit_multi": 0.0, "action_time" : 0 }

var item_name
var durability

func _ready():
	# Temp
	icon = base_icon

func create(parts : Array):
	for req_part_type in required_parts:
		var found = false
		for part in parts:
			if part.type == req_part_type:
				found = true
				break
		if !found:
			return false
	for part in parts:
		add_part(part)

func add_part(part : ItemPart):
	for child_part in get_children():
		if part.type == child_part.type:
			return false
	add_child(part)
	update_rarity(part)
	set_item_name()
	calculate_stats()
	calculate_durability()

func update_rarity(part):
	rarity = max(rarity, part.rarity)

func set_item_name():
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
	item_name = new_name

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

func apply_stats(_stats):
	for stat in stats:
		_stats[stat] += stats[stat]

func print_item():
	print("Item : %s (%s)" % [item_name, CraftingManager.RARITY.keys()[rarity]])
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
