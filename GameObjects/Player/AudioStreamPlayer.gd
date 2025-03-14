extends AudioStreamPlayer


var good_reaction = preload("res://Assets/Sounds/good.mp3")
var bad_reaction = preload("res://Assets/Sounds/bad.mp3")

func _ready():
	Bridge.game.connect("visibility_state_changed", self, "_on_visibility_state_changed")
	
func _on_visibility_state_changed(state):
	if state == 'hidden':
		playing = false
	if state == 'visible':
		playing = true



