extends Entity
class_name Monster

enum MONSTER_TYPE { BANDIT, WOLF }

signal monster_despawned
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
	._ready()
	connect("died", CombatProcessor, "_on_monster_died")
	connect("monster_despawned", CombatProcessor, "_on_monster_despawned")
	connect("loot", LootManager, "_on_loot")
	update_skill_cooldowns(true)
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
func add_modifiers(modifiers):
	for modifier in modifiers:
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

func _on_Entity_animation_finished():
	._on_Entity_animation_finished()
	if animation == "die":
		emit_signal("monster_despawned")
		queue_free()

func add_loot(_loot):
	for lootable in _loot:
		loot.append(lootable)
	return self

func drop_loot():
	emit_signal("loot", loot)
