extends AudioStreamPlayer


var chipi_chipi = preload("res://Assets/Sounds/PlayArrow_-_Chipi-Chipi-Chapa-Chapa_77099952.mp3")
var lofi = preload("res://Assets/Sounds/lofi1.mp3")
var chipi_count = 0

func _ready():
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	
func _on_visibility_state_changed(state):
	if state == 'hidden':
		playing = false
	if state == 'visible':
		playing = true

func _on_RestartMenu_ad_state_changed(state):
	if state == 'opened' or state == 'loading':
		playing = false
	if state == 'closed' or state == 'failed':
		playing = true


func _on_Player_level_changed(level):
	if level == 22:
		stop()
		stream = chipi_chipi
		play()




func _on_Game_player_finished(score):
	if stream == chipi_chipi:
		stream = lofi
		play()
