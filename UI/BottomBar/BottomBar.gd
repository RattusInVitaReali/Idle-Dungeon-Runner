extends Control
class_name BottomBar

signal change_screen

func _ready():
	rect_scale = ScreenMeasurer.get_game_scale()
	rect_position = Vector2(16, (ScreenMeasurer.height - 210 * ScreenMeasurer.screen_scale))
	rect_size.x = 1048

func _on_Combat_pressed():
	emit_signal("change_screen", Main.SCREEN.COMBAT)

func _on_Inventory_pressed():
	emit_signal("change_screen", Main.SCREEN.INVENTORY)

func _on_PartForge_pressed():
	emit_signal("change_screen", Main.SCREEN.PART_FORGE)

func _on_ItemForge_pressed():
	emit_signal("change_screen", Main.SCREEN.ITEM_FORGE)

func _on_Stats_pressed():
	emit_signal("change_screen", Main.SCREEN.STATS)

func _on_Zones_pressed():
	emit_signal("change_screen", Main.SCREEN.ZONES)

func _on_Skills_pressed():
	emit_signal("change_screen", Main.SCREEN.SKILLS)
