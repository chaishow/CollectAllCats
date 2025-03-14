extends Label





func _on_Player_level_changed(level):
	if level == 22:
		show()
	else:
		hide()
