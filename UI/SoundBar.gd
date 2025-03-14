extends HSlider


onready var soundplayer = $"../../../../AudioStreamPlayer"



func _on_value_changed(value):
	soundplayer.volume_db = value
