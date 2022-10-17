extends Trait
class_name AttributeBonusFlatTrait

export (Dictionary) var attribute_bonuses = {
	"power": 0, 
	"potency": 0, 
	"dexterity": 0, 
	"precision": 0, 
	"ferocity": 0, 
	"mastery": 0, 
	"expertise": 0, 
	"armor": 0, 
	"occult_aversion": 0, 
	"vitality": 0, 
	"toughess": 0, 
	"penetration": 0, 
	"magic_penetration": 0, 
}

func on_calculate_attributes(attributes):
	for att in attributes:
		attributes[att] += attribute_bonuses[att]

func description():
	var desc = "Gain "
	for at in attribute_bonuses:
		if attribute_bonuses[at] != 0:
			desc += str(attribute_bonuses[at]) + " " + at.capitalize() + ", "
	var index = desc.find_last(",")
	if index != -1:
		desc.erase(index, 1)
	index = desc.find_last(",")
	if index != -1:
		desc.erase(index, 1)
		desc.insert(index, " and")
	desc += "."
	return desc
