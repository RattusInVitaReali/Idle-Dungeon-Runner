extends Inspector
class_name ItemInspector

# warning-ignore:unused_signal
signal equip
# warning-ignore:unused_signal
signal unequip
signal upgrade

onready var parts = $Panel/VBoxContainer/Parts
onready var button_label = $Panel/VBoxContainer/Buttons/Equip/Label
onready var buttons_container = $Panel/VBoxContainer/Buttons
onready var buttons_line = $Panel/VBoxContainer/Line5
onready var dismantle_button = $Panel/VBoxContainer/Buttons/Dismantle

var signal_name = "equip"

var inventory = false

func set_slot(_slot):
	.set_slot(_slot)
	if slot is InventorySlot:
		inventory_variant()
	if slot.hide_inspector_buttons:
		hide_buttons()

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

func inventory_variant():
	signal_name = "unequip"
	button_label.text = "Unequip"
	dismantle_button.hide()

func hide_buttons():
	buttons_line.hide()
	buttons_container.hide()

func _on_Equip_pressed():
	emit_signal(signal_name, slottable)
	queue_free()


func _on_Upgrade_pressed():
	if inventory:
		emit_signal("upgrade", slottable)
	else:
		emit_signal("upgrade", slottable.split(1))
	queue_free()

func _on_Dismantle_pressed():
	slottable.dismantle()
	queue_free()
