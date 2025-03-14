extends TextureProgress


onready var player = $".."
var current_goal 
var previous 
signal goal_changed(goal)

func _ready():
	current_goal = calculate_new_goal(player.level)
	max_value = current_goal
	value = player.score
	$ScoreLabel.text = Utilies.scale_numb(player.score)
	previous = 0
	



func _on_player_score_changed(score):
	if score >= current_goal:
		player.set_level(player.level+1)
		previous=current_goal
		current_goal=calculate_new_goal(player.level)
		max_value = current_goal
		emit_signal("goal_changed", current_goal)
	elif score < previous:
		player.set_level(player.level-1)
		previous=calculate_new_goal(player.level-1)
		current_goal=calculate_new_goal(player.level)
		max_value=current_goal
		emit_signal("goal_changed", current_goal)
	value = stepify(score, 0.01)
	$ScoreLabel.text = Utilies.scale_numb(score)
		

func calculate_new_goal(player_level):
	var new_goal = 200*player_level+player_level*pow((player_level),(player_level-1)) - (player_level-3)*pow(player_level, (player_level-1))
	return stepify(new_goal, 0.01)

func _on_player_player_reseted():
	current_goal=calculate_new_goal(player.level)
	previous = 0
	max_value=current_goal
		
func save():
	var save_dict = {
		"curent_goal" : current_goal,
		"previous" : previous,
		"value" : value,
		"max_value" : max_value
		}
