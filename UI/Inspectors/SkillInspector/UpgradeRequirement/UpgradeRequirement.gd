extends TextureRect
class_name UpgradeRequirement

var resource
var amount = 0
var required = 0

onready var icon = $HBoxContainer/Icon
onready var amount_label = $HBoxContainer/Amount

func set_requirement(global_resource, _required):
	resource = global_resource
	required = _required
	GlobalResources.connect("global_resource_changed", self, "_on_global_resource_changed")
	icon.texture = GlobalResources.get_gr_icon(resource)
	update_text()

func _on_global_resource_changed(gr):
	if gr == resource:
		update_text()

func update_text():
	amount = GlobalResources.get_gr_quantity(resource)
	amount_label.text = str(amount) + " / " + str(required)
	if amount >= required:
		amount_label.add_color_override("font_color", Color.green)
	else:
		amount_label.add_color_override("font_color", Color.red)
