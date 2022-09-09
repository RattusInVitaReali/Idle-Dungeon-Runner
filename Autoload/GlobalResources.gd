extends GlobalSaveable
class_name GlobalResourcesScript

signal global_resource_changed

enum GR {
	SKILL_LOTUS,
	SKILL_POINT,
	SPELLSTONE_BASIC,
	SPELLSTONE_COMMON,
	SPELLSTONE_UNCOMMON,
	SPELLSTONE_RARE,
	SPELLSTONE_EPIC,
	SPELLSTONE_LEGENDARY
}

export (Dictionary) var GLOBAL_RESOURCES = {
	GR.SKILL_LOTUS:
		[0, "Skill Lotus", preload("res://_Resources/lotus.png")],
	GR.SKILL_POINT:
		[0, "Skill Point", preload( "res://_Resources/SkillIcon.png")],
	GR.SPELLSTONE_BASIC:
		[0, "Basic Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC367.png")],
	GR.SPELLSTONE_COMMON:
		[0, "Common Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC368.png")],
	GR.SPELLSTONE_UNCOMMON:
		[0, "Uncommon Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC369.png")],
	GR.SPELLSTONE_RARE:
		[0, "Rare Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC370.png")],
	GR.SPELLSTONE_EPIC:
		[0, "Epic Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC371.png")],
	GR.SPELLSTONE_LEGENDARY:
		[0, "Legendary Spellstone", preload("res://_Resources/Icon sprite sheet/Equipment Icons/EquipmentIconsC372.png")]
}

func save_path():
	return "user://globals.tscn"

func _ready():
	LootManager.connect("item_acquired", self, "_on_item_acquired")
	if CraftingManager.debug:
		for gr in GLOBAL_RESOURCES:
			GLOBAL_RESOURCES[gr][0] = 10000

func _on_item_acquired(item):
	if item.slottable_type == Slottable.SLOTTABLE_TYPE.GLOBAL_RESOURCE:
		process_slottable(item)
		item.queue_free()

func set_gr_quantity(gr, quant):
	GLOBAL_RESOURCES[gr][0] = quant
	emit_signal("global_resource_changed", gr)

func get_gr_quantity(gr):
	return GLOBAL_RESOURCES[gr][0]

func get_gr_name(gr):
	return GLOBAL_RESOURCES[gr][1]

func get_gr_icon(gr):
	return GLOBAL_RESOURCES[gr][2]

func gain_gr(gr, amount):
	set_gr_quantity(gr, get_gr_quantity(gr) + amount)

func spend_gr(gr, amount):
	set_gr_quantity(gr, get_gr_quantity(gr) - amount)

func process_slottable(slottable):
	gain_gr(slottable.global_resource, slottable.quantity)
