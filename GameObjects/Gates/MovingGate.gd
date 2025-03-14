extends "Gate.gd"

var speed = 1.3
var direction = 1

var velocity = 0
var speed_delta = 0.4


func _process(delta):
	translation.x += min(velocity+speed_delta, speed)*delta*direction
	velocity += speed_delta*delta

func _on_collision_area_body_entered(body):
	._on_collision_area_body_entered(body)
	if 'Border' in body.name:
		direction = -direction
		velocity = 0
	
