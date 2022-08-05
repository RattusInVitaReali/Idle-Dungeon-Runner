extends Item
class_name Helmet

func get_draw_order():
	var order = .get_draw_order()
	order.push_front(order.pop_back())
	return order
