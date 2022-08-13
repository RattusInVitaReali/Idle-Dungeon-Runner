extends Entity
class_name Monster

enum MONSTER_TYPE { BANDIT, WOLF, ORC, GOLEM }

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
	connect("died", CombatProcessor, "_on_monster_died")
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

func apply_modifiers():
	for modifier in modifiers:
		modifier.apply_effect(stats, level)

func update_stats():
	.update_stats()
	apply_modifiers()
	update_skill_cooldowns(true)

func update_skill_levels():
	for skill in get_skills():
		skill.set_level(level)

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

func power_level():
	return int(level + modifiers.size() * (modifiers.size() + 1) / 2) * (1 + modifiers.size() * 0.1)

func add_loot(_loot):
	for lootable in _loot:
		loot.append(lootable)
	return self

func drop_loot():
	set_lootable_level()
	emit_signal("loot", loot)

func _get_loot():
	set_lootable_level()
	return LootManager.roll_loot(loot)

func set_lootable_level():
	for lootable in loot:
		lootable.set_level(power_level())

func _on_Entity_animation_finished():
	._on_Entity_animation_finished()
	if animation == "die":
		queue_free()
