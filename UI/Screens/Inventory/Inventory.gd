extends Screen
class_name Inventory

onready var items = $VBoxContainer/Screen/VBoxContainer/SlottableInventory
onready var weapon1 = $VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/VBoxContainer/Line4/Weapon1
onready var weapon2 = $VBoxContainer/Screen/VBoxContainer/Center/HBoxContainer/EquipmentBackground/VBoxContainer/Line4/Weapon2

onready var gear_slots = [weapon1, weapon2]

var player = null

func _ready():
	for slot in gear_slots:
		slot.connect("inspector", self, "_on_inspector")
		slot.gear = true;
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")
	items.connect("inspector", self, "_on_inspector")

func _on_player_spawned(_player):
	player = _player
	player.connect("items_changed", self, "update_equipped")

func add_item(item):
	items.add_slottable(item)

func _on_inspector(slottable, gear):
	var inspector = ._on_inspector(slottable, gear)
	inspector.connect("equip", self, "_on_equip")
	inspector.connect("unequip", self, "_on_unequip")

func _on_equip(item):
	items.remove_slottable(item)
	CombatProcessor.Player.equip_item(item)

func _on_unequip(item):
	CombatProcessor.Player.unequip_item(item)

func _on_items_changed():
	update_equipped()

func update_equipped():
	for slot in gear_slots:
		slot.set_slottable(null)
	var weapon_count = 0
	for item in CombatProcessor.Player.get_items():
		match item.type:
			CraftingManager.ITEM_TYPE.WEAPON:
				weapon_count += 1
				if weapon_count == 1:
					weapon1.set_slottable(item)
				else:
					weapon2.set_slottable(item)
			CraftingManager.ITEM_TYPE.ARMOR:
				match item.subtype:
					CraftingManager.ITEM_SUBTYPE.BODY_ARMOR:
						pass
					# etc.
