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
		return true
	return false

func get_parts():
	return get_children()

func reorder_parts():
	var parts = get_children()
	parts.sort_custom(self, "_sort_type")
	for part in get_children():
		remove_child(part)
	for part in parts:
		add_child(part)

static func _sort_type(a, b):
	if a == null or b == null:
		return false
	if a.type == null or b.type == null:
		return false
	if a.type > b.type:
		return true
	return false

func add_part(part : ItemPart):
	for child_part in get_children():
		if part.type == child_part.type:
			tier -= child_part.tier
			remove_child(child_part)
			child_part.queue_free()
			break
	add_child(part)
	update_rarity()
	set_slottable_name()
	calculate_stats()
	calculate_durability()
	update_special()
	update_icon()
	reorder_parts()
	tier += part.tier
	emit_signal("slottable_updated")

func update_rarity():
	rarity = CraftingManager.RARITY.BASIC
	for child_part in get_children():
		rarity = max(rarity, child_part.rarity)

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

func update_icon():
	icon = base_icon # Temp

func apply_attributes(_stats):
	for stat in stats:
		_stats[stat] += stats[stat]

func print_item():
	print("Item : %s (%s)" % [slottable_name, CraftingManager.RARITY.keys()[rarity]])
	print("- Durability : %s" % durability)
	for stat in stats:
		if stats[stat] != 0:
			print("- %s : %s" % [stat.capitalize(), stats[stat]])
	print()

func same_as(item : Slottable):
	if item == null:
		return false
	var properties_to_compare = [
		"slottable_name",
		"durability",
		"type",
		"subtype"
	]
	for prop in properties_to_compare:
		if get(prop) != item.get(prop):
			return false
	if get_child_count() != item.get_child_count():
		return false
	var i = 0
	while i < get_child_count():
		if !get_child(i).same_as(item.get_child(i)):
			return false
		i += 1
	return true

func special_copy(var new_item : Item):
	new_item.custom_name = custom_name
	for part in get_children():
		part.quantity(part.quantity + 1)
		var new_part = part.split(1)
		new_item.add_part(new_part)

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
