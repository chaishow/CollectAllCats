extends Button

onready var bank = $"../../Bank"
onready var label = $Label
onready var game = $"../../.."

signal upgrade_changed(percent)

var upgrade_cost = 100
var upgrade_delta = 0.015
var curent_upgrade = 0

func _ready():
	update_label()

func _on_button_up():
	if bank.is_enough_money(upgrade_cost):
		bank.spend_money(upgrade_cost)
		set_upgrage(curent_upgrade+upgrade_delta)
		upgrade_cost *= 1.75
		upgrade_cost = stepify(upgrade_cost, 0.01)
		update_label()
		game.save_game()

func set_upgrage_cost(cost):
	upgrade_cost = cost
	update_label()

func set_upgrage(value):
	curent_upgrade = value
	update_label()
	emit_signal("upgrade_changed", curent_upgrade)

func update_label():
	label.text = 'Продать дороже \n +' + str((curent_upgrade+upgrade_delta)*100) + '% \n Стоимость \n' + Utilies.scale_numb(upgrade_cost)

func save():
	var save_dict = {
		"name": get_path(),
		"curent_upgrade" : curent_upgrade,
		"upgrade_cost": upgrade_cost
	}
	
	return save_dict

func to_load(save_dict):
	set_upgrage(save_dict["curent_upgrade"])
	set_upgrage_cost(save_dict["upgrade_cost"])
	update_label()
