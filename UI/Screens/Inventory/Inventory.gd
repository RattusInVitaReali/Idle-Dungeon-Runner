extends Screen
class_name InventoryUI

signal upgrade

const Attribute = preload("res://UI/Screens/Inventory/Attribute/Attribute.tscn")

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory
onready var attributes_container = $VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/AttributesBackground/ScrollContainer/AttributeContainer

onready var weapon_slots = [
	$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Weapon1,
	$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Weapon2
]

onready var armor_slots = {
	CraftingManager.ITEM_SUBTYPE.BODY_ARMOR: 
		$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/BodyArmor,
	CraftingManager.ITEM_SUBTYPE.HELMET:
		$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Helmet
}

onready var ring_slots = [
	$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Ring1,
	$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Ring2
]

onready var accessory_slots = {
	CraftingManager.ITEM_SUBTYPE.AMULET:
		$VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/GridContainer/Amulet
}

onready var all_slots

var player = null
var attributes_init = false

func _ready():
	all_slots = weapon_slots.duplicate()
	for type in armor_slots:
		all_slots.append(armor_slots[type])
	for slot in all_slots:
		slot.connect("inspector", self, "_on_inspector")
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")
	items.connect("inspector", self, "_on_inspector")

func _on_player_spawned(_player):
	if _player != player:
		player = _player
		player.connect("items_changed", self, "_on_items_changed")
		player.connect("stats_updated", self, "update_attributes")
		update_equipped()
		update_attributes()

func add_item(item):
	items.add_slottable(item)

func _on_inspector(slottable):
	var inspector = ._on_inspector(slottable)
	if inspector != null:
		inspector.connect("equip", self, "_on_equip")
		inspector.connect("unequip", self, "_on_unequip")
		inspector.connect("upgrade", self, "_on_upgrade")

func _on_equip(item):
	var item_to_equip = items.remove_slottable(item, 1)
	CombatProcessor.Player.equip_item(item_to_equip)

func _on_unequip(item):
	CombatProcessor.Player.unequip_item(item)

func _on_upgrade(item):
	emit_signal("upgrade", item)

func _on_items_changed():
	update_equipped()

func update_equipped():
	for slot in all_slots:
		slot.set_slottable(null)
	var weapon_count = 0
	var ring_count = 0
	for item in CombatProcessor.Player.get_items():
		match item.type:
			CraftingManager.ITEM_TYPE.WEAPON:
				weapon_slots[weapon_count].set_slottable(item)
				weapon_count += 1
			CraftingManager.ITEM_TYPE.ARMOR:
				armor_slots[item.subtype].set_slottable(item)
			CraftingManager.ITEM_TYPE.ACCESSORY:
				match item.subtype:
					CraftingManager.ITEM_SUBTYPE.RING:
						ring_slots[ring_count].set_slottable(item)
						ring_count += 1
					_:
						accessory_slots[item.subtype].set_slottable(item)

func update_attributes():
	var _attributes = player.attributes
	if !attributes_init:
		for _at in _attributes:
			attributes_container.add_child(Attribute.instance())
		attributes_init = true
	var attribute_lines = attributes_container.get_children()
	var i = 0
	for at in _attributes:
		attribute_lines[i].init(at.capitalize(), str(_attributes[at]))
		i += 1
