extends Slottable
class_name GlobalResourceSlottable

export (GlobalResources.GR) var global_resource

func from_lootable(lootable):
	global_resource = lootable.global_resource
	slottable_name = GlobalResources.get_gr_name(global_resource)
	icon = GlobalResources.get_gr_icon(global_resource)
	return self

func same_as(slottable : Slottable):
	return slottable.slottable_type == SLOTTABLE_TYPE.GLOBAL_RESOURCE and slottable.global_resource == global_resource
