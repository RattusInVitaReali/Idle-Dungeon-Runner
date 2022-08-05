extends Item
class_name Pants

func get_draw_order():
	var order = .get_draw_order()
	order.insert(1, order.pop_back())
	return order
