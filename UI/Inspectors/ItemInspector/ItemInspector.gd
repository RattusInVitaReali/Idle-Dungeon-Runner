extends Inspector
class_name ItemInspector

signal equip
signal unequip
signal upgrade

onready var parts = $Panel/VBoxContainer/Parts
onready var button_label = $Panel/VBoxContainer/Buttons/Equip/Label
onready var buttons_container = $Panel/VBoxContainer/Buttons

var signal_name = "equip"

func set_slottable(_slottable):
	.set_slottable(_slottable)
	update_parts()

func update_parts():
	var p = ""
	for part in slottable.get_parts():
		p += part.slottable_name
		if part.tier > 0:
			p+= " (" + str(part.tier) + "*)"
		p += " - "
	p.erase(p.length() - 3, 3)
	parts.text = p

func gear_variant():
	.gear_variant()
	signal_name = "unequip"
	button_label.text = "Unequip"

func upgrade_variant():
	.upgrade_variant()
	buttons_container.hide()

func _on_Equip_pressed():
	emit_signal(signal_name, slottable)
	queue_free()


func _on_Upgrade_pressed():
	if gear:
		emit_signal("upgrade", slottable)
	else:
		emit_signal("upgrade", slottable.split(1))
	queue_free()
