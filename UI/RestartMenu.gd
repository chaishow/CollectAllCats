extends Control


var current_score = 0
var sale_coef = 1

onready var bank = $"../Bank"
onready var game = $"../.."

func _ready():
	hide()

func _on_game_player_finished(score):
	current_score = score


func _on_sell_button_button_up():
	bank.add_money(current_score*sale_coef)
	game.restart_game()


func _on_CoefButton_upgrade_changed(percent):
	sale_coef = 1+stepify(percent, 0.001)
