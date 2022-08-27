extends GlobalSaveable
class_name ProgressionScript

signal progression_monster_died

export var item_part_unlocked = {
	CraftingManager.PART_TYPE.SWORD_BLADE : true,
	CraftingManager.PART_TYPE.SWORD_HANDLE : true,
	CraftingManager.PART_TYPE.SWORD_GUARD : false,
	CraftingManager.PART_TYPE.POMMEL : false,
	
	CraftingManager.PART_TYPE.AXE_HEAD : false,
	CraftingManager.PART_TYPE.AXE_HANDLE : false,
	CraftingManager.PART_TYPE.SECONDARY_AXE_HEAD : false,
	
	CraftingManager.PART_TYPE.TUNIC : true,
	CraftingManager.PART_TYPE.CHESTPLATE : true,
	CraftingManager.PART_TYPE.SHOULDERS : false,
	CraftingManager.PART_TYPE.ARMS : false, 
	
	CraftingManager.PART_TYPE.PANTS_LINING : false,
	CraftingManager.PART_TYPE.SIDEGUARDS : false, 
	CraftingManager.PART_TYPE.SHINGUARDS : false, 
	CraftingManager.PART_TYPE.KNEEPADS : false,
	CraftingManager.PART_TYPE.OVERPANTS : false,
	
	CraftingManager.PART_TYPE.HELMET_LINING : false,
	CraftingManager.PART_TYPE.HELMET_PROTECTION : false, 
	CraftingManager.PART_TYPE.ORNAMENT : false, 
	CraftingManager.PART_TYPE.VISOR : false, 
	CraftingManager.PART_TYPE.NECKGUARD : false,
	
	CraftingManager.PART_TYPE.BOOT_LINING : false,
	CraftingManager.PART_TYPE.BOOT_PROTECTION : false,
	CraftingManager.PART_TYPE.CALFGUARDS : false,
	CraftingManager.PART_TYPE.BOOT_COLLARS : false,
	
	CraftingManager.PART_TYPE.GLOVE_LINING : false, 
	CraftingManager.PART_TYPE.HAND_PROTECTION : false, 
	CraftingManager.PART_TYPE.FOREARM_PROTECTION : false, 
	
	CraftingManager.PART_TYPE.CHAIN : false, 
	CraftingManager.PART_TYPE.FOCUS : false, 
	CraftingManager.PART_TYPE.CROWN : false, 
	
	CraftingManager.PART_TYPE.RING_BAND : false, 
	CraftingManager.PART_TYPE.RING_BEADS : false
}

export var item_unlocked = {
	CraftingManager.ITEM_SUBTYPE.SWORD : true,
	CraftingManager.ITEM_SUBTYPE.AXE : false,
	CraftingManager.ITEM_SUBTYPE.BODY_ARMOR : true,
	CraftingManager.ITEM_SUBTYPE.PANTS : false,
	CraftingManager.ITEM_SUBTYPE.HELMET : false,
	CraftingManager.ITEM_SUBTYPE.BOOTS : false,
	CraftingManager.ITEM_SUBTYPE.GLOVES : false,
	CraftingManager.ITEM_SUBTYPE.AMULET : false,
	CraftingManager.ITEM_SUBTYPE.RING : false
}

func save_path():
	return "user://progression.tscn"

func _ready():
	CombatProcessor.connect("monster_died", self, "_on_monster_died")

func _on_monster_died(monster, zone):
	emit_signal("progression_monster_died", monster, zone)

func unlock_part(part):
	item_part_unlocked[part.type] = true

func unlock_item(item):
	item_unlocked[item.type] = true

func load():
	if save_path != "" and ResourceLoader.exists(save_path):
		var instance = load(save_path).instance()
		for prop in instance.get_property_list():
			if prop.usage == 8199: # EXPORT VAR
				if prop.type in [18, 19]:
					set(prop.name, instance.get(prop.name).duplicate())
				else:
					set(prop.name, instance.get(prop.name))
		instance.queue_free()

func save_and_exit():
	Saver.save_scene(self, save_path)
