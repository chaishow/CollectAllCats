extends Spatial


var level_coef = 1
var coef  
var score
var enabled = true

onready var mesh = $GateMesh


func _ready():
	coef = [-1, 1, 1][randi()%2]
	mesh.set_material_override(load("res://Assets/Materials/negative_gates_material.tres"))
	score = (randi()%200+1)*coef*level_coef
	$Label3D.text = Utilies.scale_numb(score)
	if score > 0:
		$Label3D.text = '+'+Utilies.scale_numb(score)
		mesh.set_material_override(load("res://Assets/Materials/positive_gates_material.tres"))
	

func _on_collision_area_body_entered(body):
	if body.name == 'Player' and enabled:
		body.increase_score(score)
		queue_free()

