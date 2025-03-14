extends Control


var money_amount = 0
signal money_amount_changed(amount)

func add_money(amount):
	money_amount += amount
	money_amount = stepify(money_amount, 0.01)
	emit_signal("money_amount_changed", money_amount)
	
func spend_money(amount):
	if is_enough_money(amount):
		money_amount -= amount
		money_amount = stepify(money_amount, 0.01)
		emit_signal("money_amount_changed", money_amount)
		
func set_money(amount):
	money_amount = amount
	emit_signal("money_amount_changed", money_amount)

func is_enough_money(amount):
	if amount <= money_amount:
		return true
	return false

func save():
	var save_dict = {
		"name": get_path(),
		"money_amount": money_amount
	}
	return save_dict
	
func to_load(save_dict):
	set_money(save_dict['money_amount'])
	
