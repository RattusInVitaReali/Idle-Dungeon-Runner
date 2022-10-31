extends StatsInspector
class_name ItemInspector

# warning-ignore:unused_signal
signal equip
# warning-ignore:unused_signal
signal unequip
signal upgrade

onready var parts = $Panel/VBoxContainer/Parts
onready var button_label = $Panel/VBoxContainer/Buttons/Button1/Label
onready var buttons_container = $Panel/VBoxContainer/Buttons
onready var buttons_line = $Panel/VBoxContainer/ButtonsLine
onready var button_3 = $Panel/VBoxContainer/Buttons/Button3

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

func update_special():
	if slottable.special != "":
		special.text = slottable.special
	else:
		special.hide()
		special_line.hide()

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
	inventory = true
	signal_name = "unequip"
	button_label.text = "Unequip"
	button_3.hide()

func hide_buttons():
	buttons_line.hide()
	buttons_container.hide()

func _on_Button1_pressed():
	emit_signal(signal_name, slottable)
	queue_free()

func _on_Button2_pressed():
	if inventory:
		emit_signal("upgrade", slottable)
	else:
		emit_signal("upgrade", slottable.split(1))
	queue_free()

func _on_Button3_pressed():
	get_confirm_response("Are you sure you want to dismantle ALL " + slottable.slottable_name + "s? You will get 25% of the materials required to craft them.")
	if yield(self, "confirm_response"):
		slottable.dismantle()
		queue_free()

