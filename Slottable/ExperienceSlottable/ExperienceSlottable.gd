extends Slottable
class_name ExperienceSlottable

func same_as(slottable : Slottable):
	return slottable.slottable_type == SLOTTABLE_TYPE.EXPERIENCE
