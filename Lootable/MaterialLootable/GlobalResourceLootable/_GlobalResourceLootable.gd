extends MaterialLootable
class_name GlobalResourceLootable

export (String) var global_resource_name

func get_loot():
	GlobalResources.set(global_resource_name, GlobalResources.get(global_resource_name) + get_quantity())
	return null
