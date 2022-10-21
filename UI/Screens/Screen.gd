extends Control
class_name Screen

const MaterialInspector = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/MaterialInspector/MaterialInspector.tscn")
const PartInspector = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/PartInspector/PartInspector.tscn")
const ItemInspector = preload("res://UI/FullScreenPopup/SlottableInspector/StatsInspector/ItemInspector/ItemInspector.tscn")
const SkillInspector = preload("res://UI/FullScreenPopup/SlottableInspector/SkillInspector/SkillInspector.tscn")
const TraitInspectorScene = preload( "res://UI/FullScreenPopup/SlottableInspector/TraitInspector/TraitInspector.tscn")

const ConfirmDialog = preload("res://UI/ConfirmDialog/ConfirmDialog.tscn")

const GlobalResourceIcon = preload("res://UI/Screens/GlobalResourceIcon.tscn")

signal confirm_response

export (Array, GlobalResourcesScript.GR) var global_resources

var upper
var resources_background
var resources_container

var inspector = null

var player : Player = null

func _ready():
	if has_node("VBoxContainer/Upper"):
		upper = $VBoxContainer/Upper
		resources_background = $VBoxContainer/Upper/VBoxContainer/ResourcesBackground
		resources_container = $VBoxContainer/Upper/VBoxContainer/ResourcesBackground/GridContainer
		set_global_resources()
	CombatProcessor.connect("player_spawned", self, "_on_player_spawned")
	rect_size = ScreenMeasurer.get_screen_size()

func set_global_resources():
	if global_resources.size() == 0:
		resources_background.hide()
		upper.rect_min_size -= Vector2(0, 100)
		return
	if global_resources.size() > 4:
		var extend = 100 * ceil(float(global_resources.size() - 4) / 4)
		upper.rect_min_size += Vector2(0, extend)
		resources_background.rect_min_size += Vector2(0, extend)
	for gr in global_resources:
		var gr_icon = GlobalResourceIcon.instance()
		resources_container.add_child(gr_icon)
		gr_icon.initialize(gr)

func get_confirm_response(question):
	var confirm_dialog = ConfirmDialog.instance()
	add_child(confirm_dialog)
	confirm_dialog.set_question(question)
	emit_signal("confirm_response", yield(confirm_dialog, "response"))

func _on_player_spawned(_player):
	player = _player

func _on_inspector(slot):
	var slottable = slot.slottable
	inspector = null
	if slottable != null:
		match slottable.slottable_type:
			Slottable.SLOTTABLE_TYPE.MATERIAL:
				inspector = MaterialInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM_PART:
				inspector = PartInspector.instance()
			Slottable.SLOTTABLE_TYPE.ITEM:
				inspector = ItemInspector.instance()
			Slottable.SLOTTABLE_TYPE.SKILL:
				inspector = SkillInspector.instance()
			Slottable.SLOTTABLE_TYPE.TRAIT:
				inspector = TraitInspectorScene.instance()
		if inspector != null:
			add_child(inspector)
			inspector.set_slot(slot)
	return inspector

func on_focused():
	pass

func on_lost_focus():
	if inspector != null and weakref(inspector).get_ref():
		inspector.queue_free()
