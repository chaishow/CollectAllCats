extends Button

onready var player = $"../../../Player"
onready var bank = $"../../Bank"
onready var label = $Label
onready var game = $"../../.."
onready var score_bar=player.get_node('ScoreBar')
var upgrade
var upgrade_cost = 100

func _ready():
	upgrade = 0.25*score_bar.current_goal
	label.text = 'Прокачать котика +' + '\n' + Utilies.scale_numb(upgrade)+'' + '\n' + 'Стоимость \n' + Utilies.scale_numb(upgrade_cost)
	

func _on_button_up():
	if bank.is_enough_money(upgrade_cost):
		
		bank.spend_money(upgrade_cost)
		
		if player.score + upgrade>= score_bar.current_goal:
			player.start_level+=1
		player.set_start_score(upgrade)
		upgrade = 0.25*score_bar.current_goal
		upgrade = stepify(upgrade, 0.01)
		upgrade_cost *= 1.75
		if player.level > 9:
			upgrade_cost += 0.4*upgrade_cost
		upgrade_cost = stepify(upgrade_cost, 0.01)
		label.text = 'Прокачать котика \n +' + Utilies.scale_numb(upgrade) + '\n Стоимость \n' + Utilies.scale_numb(upgrade_cost)
		game.save_game()

func set_upgrage_cost(cost):
	upgrade_cost = cost
	label.text = 'Прокачать котика \n +' + Utilies.scale_numb(upgrade) + '\n Стоимость \n' + Utilies.scale_numb(upgrade_cost)

func set_upgrage(value):
	upgrade = value
	label.text = 'Прокачать котика \n +' + Utilies.scale_numb(upgrade) + '\n Стоимость \n' + Utilies.scale_numb(upgrade_cost)

func save():
	var save_dict = {
		"name": get_path(),
		"upgrade" : upgrade,
		"upgrade_cost": upgrade_cost
	}
	
	return save_dict

func to_load(save_dict):
	set_upgrage(save_dict["upgrade"])
	set_upgrage_cost(save_dict["upgrade_cost"])
