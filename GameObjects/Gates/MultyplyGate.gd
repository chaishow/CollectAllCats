extends "Gate.gd"

func _ready():
	coef=stepify(rand_range(0.2,4.0),0.01)
	if coef > 0.99:
		mesh.set_material_override(load("res://Assets/Materials/positive_gates_material.tres"))
	else:
		mesh.set_material_override(load("res://Assets/Materials/negative_gates_material.tres"))
	$Label3D.text = 'x' + str(coef)

func _on_collision_area_body_entered(body):
	if body.name == 'Player' and enabled:
		
		body.multiply_score(coef)
		queue_free()

