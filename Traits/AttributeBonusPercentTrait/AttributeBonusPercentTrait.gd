extends Trait
class_name AttributeBonusPercentTrait

export (Dictionary) var attribute_multipliers = {
	"power": 1.0, 
	"potency": 1.0, 
	"dexterity": 1.0, 
	"precision": 1.0, 
	"ferocity": 1.0, 
	"mastery": 1.0, 
	"expertise": 1.0, 
	"armor": 1.0, 
	"occult_aversion": 1.0, 
	"vitality": 1.0, 
	"toughess": 1.0, 
	"penetration": 1.0, 
	"magic_penetration": 1.0, 
}

func on_calculate_attributes(attributes):
	for att in attributes:
		attributes[att] *= attribute_multipliers[att]

func description():
	var desc = "Gain "
	for at in attribute_multipliers:
		if attribute_multipliers[at] != 1.0:
			desc += str((attribute_multipliers[at] - 1) * 100) + "% " + at.capitalize() + ", "
	var index = desc.find_last(",")
	if index != -1:
		desc.erase(index, 2)
	index = desc.find_last(",")
	if index != -1:
		desc.erase(index, 1)
		desc = desc.insert(index, " and")
	desc += "."
	return desc
