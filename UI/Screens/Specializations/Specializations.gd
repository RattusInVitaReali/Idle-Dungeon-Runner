extends Screen
class_name Specializations

const SpecializationInfo = preload("res://UI/Screens/Specializations/SpecializationInfo/SpecializationInfo.tscn")
const SpecializationInspector = preload("res://UI/FullScreenPopup/SpecializationInspector/SpecializationInspector.tscn")

onready var specs_container = $VBoxContainer/Screen/VBoxContainer/ScrollContainer/SpecializationsContainer

func _on_player_spawned(_player):
	if _player != player:
		._on_player_spawned(_player)
		for spec in player.get_all_specs():
			if spec.active:
				make_spec_info(spec)
		for spec in player.get_all_specs():
			if !spec.active:
				make_spec_info(spec)

func make_spec_info(spec):
	var new_info = SpecializationInfo.instance()
	specs_container.add_child(new_info)
	new_info.set_specialization(spec)
	new_info.connect("inspector", self, "_on_inspector")

func _on_inspector(slot):
	if slot is Specialization:
		var inspector = SpecializationInspector.instance()
		add_child(inspector)
		inspector.set_spec(slot)
		inspector.connect("inspector", self, "_on_inspector")
		return inspector
	var inspector = ._on_inspector(slot)
	if inspector is TraitInspector:
		inspector.connect("try_allocate", self, "_on_try_allocate")

func _on_try_allocate(spec, trait):
	spec.try_allocate(trait)
