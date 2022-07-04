extends Inspector
class_name ItemInspector

signal equip
signal unequip
signal upgrade

onready var parts = $Panel/VBoxContainer/Parts
onready var button_label = $Panel/VBoxContainer/Buttons/Equip/Label

var signal_name = "equip"

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_parts()

func update_parts():
	var p = ""
	for part in slottable.get_parts():
		p += part.slottable_name
		p += " - "
	p.erase(p.length() - 3, 3)
	parts.text = p

func gear_variant():
	signal_name = "unequip"
	yield(self, "ready")
	button_label.text = "Unequip"

func _on_Equip_pressed():
	emit_signal(signal_name, slottable)
	queue_free()


func _on_Upgrade_pressed():
	emit_signal("upgrade", slottable)
	queue_free()
