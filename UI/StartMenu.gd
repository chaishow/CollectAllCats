extends Control


onready var level = $"../.."
onready var bank = $"../Bank"


func _on_start_button_button_up():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	level.start_new_game()
	hide()
