extends HBoxContainer
class_name GlobalResourceIcon

var global_resource

func initialize(gr):
	global_resource = gr
	$Icon.texture = GlobalResources.get_gr_icon(global_resource)
	GlobalResources.connect("global_resource_changed", self, "update_value")
	update_value()

func update_value(gr = global_resource):
	if gr == global_resource:
		$Amount.text = str(GlobalResources.get_gr_quantity(global_resource))
