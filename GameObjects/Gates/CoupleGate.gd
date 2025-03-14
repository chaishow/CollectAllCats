extends Spatial


var children

var level_coef = 1


func _on_Gate_player_went_throught():
	for child in get_children():
		child.enabled = false
		
