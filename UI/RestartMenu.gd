extends Control


var current_score = 0
var sale_coef = 1

onready var bank = $"../Bank"
onready var game = $"../.."

signal ad_state_changed(state)

func _ready():
	hide()
	Bridge.advertisement.connect("rewarded_state_changed", self, "_on_rewarded_state_changed")


func _on_game_player_finished(score):
	current_score = score


func _on_sell_button_button_up():
	bank.add_money(current_score*sale_coef)
	game.restart_game()



func _on_sell_x_2_button_button_up():
	Bridge.advertisement.show_rewarded()
	


func _on_rewarded_state_changed(state):
	emit_signal("ad_state_changed", state)
	if state == 'rewarded':
		bank.add_money(current_score*sale_coef*2)
	if state == 'closed':
		bank.add_money(current_score*sale_coef)
		game.restart_game()
	if state == 'failed':
		bank.add_money(current_score*sale_coef)

		


func _on_CoefButton_upgrade_changed(percent):
	sale_coef = 1+stepify(percent, 0.001)
