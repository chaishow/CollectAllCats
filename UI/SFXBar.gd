extends HSlider


onready var player = $"../../../../Player"
var sfx_player


func _ready():
	sfx_player = player.get_node('AudioStreamPlayer')



func _on_value_changed(value):
	sfx_player.volume_db = value
