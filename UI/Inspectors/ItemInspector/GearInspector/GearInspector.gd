extends ItemInspector

signal unequip

func _on_Equip_pressed():
	emit_signal("unequip", slottable)
	queue_free()
