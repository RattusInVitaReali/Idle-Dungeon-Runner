extends Slottable
class_name GlobalResourceSlottable

export (GlobalResourcesScript.GLOBAL_RESOURCES) var global_resource

func from_lootable(lootable):
	global_resource = lootable.global_resource
	slottable_name = GlobalResources.GLOBAL_RESOURCES.keys()[global_resource].capitalize()
	icon = GlobalResources.global_resource_icons[global_resource]
	return self

func same_as(slottable : Slottable):
	return slottable.slottable_type == SLOTTABLE_TYPE.GLOBAL_RESOURCE and slottable.global_resource == global_resource
