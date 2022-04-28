extends Control

signal change_screen

func _on_Combat_pressed():
	emit_signal("change_screen", Main.SCREEN.COMBAT)

func _on_Inventory_pressed():
	emit_signal("change_screen", Main.SCREEN.INVENTORY)

func _on_PartForge_pressed():
	emit_signal("change_screen", Main.SCREEN.PART_FORGE)

func _on_ItemForge_pressed():
	emit_signal("change_screen", Main.SCREEN.ITEM_FORGE)
