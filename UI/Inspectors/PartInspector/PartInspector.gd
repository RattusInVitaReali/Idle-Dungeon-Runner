extends Inspector
class_name PartInspector


func _on_Button1_pressed():
	LootManager.get_item(slottable.try_to_merge())
	queue_free()

func _on_TextureButton_pressed():
	queue_free()

func _on_Button2_pressed():
	slottable.dismantle()
	queue_free()
