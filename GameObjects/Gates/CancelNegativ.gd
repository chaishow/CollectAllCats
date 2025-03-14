extends "Gate.gd"


func _ready():
	$Label3D.text = 'Всё'+'\n'+'в плюс'
	mesh.set_material_override(load("res://Assets/Materials/positive_gates_material.tres"))
	


func _on_collision_area_body_entered(body):
	if body.name == 'Player' and enabled:
		body.no_negative=true
		queue_free()

