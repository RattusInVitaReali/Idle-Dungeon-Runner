extends Entity
class_name Monster

enum MONSTER_TYPE { BANDIT, WOLF, ORC, GOLEM, GOATMAN, BULLMAN, WRAITH, TROLL }

signal loot

export var base_name = "Monster"
export (Array, Resource) var base_loot
export (Array, MONSTER_TYPE) var monster_types

var loot = []

var monster_name
var modifiers = []

var prefixes = []
var suffixes = []

func _ready():
	connect("loot", LootManager, "_on_loot")
	make_name()
	play("idle")
	loot += base_loot.duplicate()
	ready = true
	update_stats()

func enter_combat():
	.enter_combat()
	set_target(CombatProcessor.Player)
	start_action_timer()

# ZoneInfo calls this
func add_modifiers(_modifiers):
	for modifier in _modifiers:
		add_modifier(modifier)
	return self

func add_modifier(modifier):
	modifiers.append(modifier)
	if modifier.prefix:
		prefixes.append(modifier.mod_name)
	if modifier.suffix:
		suffixes.append(modifier.mod_name)
	update_stats()
	return self

func calculate_stats():
	.calculate_stats()
	apply_modifiers()
	update_skill_cooldowns(true)

func apply_vitality():
	if level < 17:
		stats["max_hp"] += int(attributes["vitality"] * (1 + pow(level, 1.5) * 0.1))
	elif level < 66:
		stats["max_hp"] += int(attributes["vitality"] * level / 2 - 0.5)
	else:
		stats["max_hp"] += int(attributes["vitality"] * 4 * sqrt(level))

func apply_modifiers():
	for modifier in modifiers:
		modifier.apply_effect(stats, level)

func apply_level_attributes():
	for key in per_level.keys():
		attributes[key] += int(per_level[key] * pow(level, 1.1))

func update_skill_levels():
	for skill in get_skills():
		skill.set_level(int(level / 2 * get_skills().size()))

func make_name():
	monster_name = base_name
	if not prefixes.empty():
		var prefix = prefixes[Random.rng.randi() % len(prefixes)]
		monster_name = prefix + " " + base_name
	if not suffixes.empty():
		var suffix = suffixes[Random.rng.randi() % len(suffixes)]
		monster_name += " " + suffix

func die():
	.die()
	drop_loot()

func add_loot(_loot):
	for lootable in _loot:
		loot.append(lootable)
	return self

func drop_loot():
	emit_signal("loot", loot, level)

func get_lootables():
	return loot

func on_die_finished():
	.on_die_finished()
	queue_free()
