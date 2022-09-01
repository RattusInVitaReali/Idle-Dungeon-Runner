extends NinePatchRect
class_name ZoneInfo

const Slot = preload("res://UI/Slot/Slot.tscn")

signal play_zone
signal inspector

onready var zone_level = $ZoneBackground/HBoxContainer/LevelDisplay/Level
onready var zone_name = $ZoneBackground/HBoxContainer/MidPart/ZoneName
onready var available_loot = $ZoneBackground/HBoxContainer/MidPart/ScrollContainer/AvailableLoot
onready var slottables = $ZoneBackground/HBoxContainer/MidPart/ScrollContainer/Slottables

onready var buttons = [
	$ZoneBackground/HBoxContainer/LevelControl/LevelUp,
	$ZoneBackground/HBoxContainer/LevelControl/LevelDown,
	$ZoneBackground/HBoxContainer/Play
]

var zone : Zone = null;

func set_zone(_zone):
	zone = _zone
	zone.connect("unlocked", self, "update_zone")
	zone.connect("zone_updated", self, "update_zone")
	update_zone()

func _on_LevelUp_pressed():
	zone.level_up()

func _on_LevelDown_pressed():
	zone.level_down()

func _on_Play_pressed():
	play_zone()

func play_zone():
	emit_signal("play_zone", zone)

func update_level():
	if zone.locked:
		zone_level.text = "Level\n???"
	else:
		zone_level.text = "Level\n" + str(zone.level)

func update_name():
	if zone.locked:
		zone_name.text = "LOCKED"
	else:
		zone_name.text = zone.zone_name + " : " + str(zone.min_level) + " - " + str(zone.max_level)

func update_background():
	yield(get_tree(), "idle_frame")
	if zone.locked:
		$ZoneBackground.texture = null
	else:
		var new_atlas = AtlasTexture.new()
		new_atlas.atlas = zone.texture
		new_atlas.region = Rect2((1800 - ScreenMeasurer.get_screen_size().x) / 4, 500, $ZoneBackground.rect_size.x, $ZoneBackground.rect_size.y)
		$ZoneBackground.texture = new_atlas

func update_buttons():
	for button in buttons:
		if zone.locked:
			button.disabled = true
		else:
			button.disabled = false

func update_loot():
	for slot in available_loot.get_children():
		slot.queue_free()
	for slottable in slottables.get_children():
		slottable.queue_free()
	for monster in zone.get_monster_instances():
		add_child(monster)
		for lootable in monster.get_lootables():
			slot_from_lootable(lootable)
		monster.queue_free()
	for quest in zone.quests:
		for lootable in quest.get_lootables():
			slot_from_lootable(lootable)

func slot_from_lootable(lootable):
	if lootable.min_level > zone.max_level or lootable.max_level < zone.min_level:
		return
	var loot = lootable.get_loot().set_quantity(1)
	for slot in available_loot.get_children():
		if slot.slottable.same_as(loot):
			loot.queue_free()
			return
	var new_slot = Slot.instance()
	available_loot.add_child(new_slot)
	lootable.set_level(1)
	slottables.add_child(loot)
	new_slot.hide_quantity = true
	new_slot.set_slottable(loot)
	new_slot.connect("inspector", self, "_on_inspector")

func _on_inspector(slot):
	emit_signal("inspector", slot)

var loot_set = false
func update_zone():
	update_level()
	update_name()
	update_background()
	update_buttons()
	if not loot_set:
		loot_set = true
		update_loot()
