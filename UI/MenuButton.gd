extends Button

onready var game = $"../.."



func _on_button_up():
	game.pause()
