extends Camera

var can_move = false
var mouse_is_pressed = false
var mouse_velocity = 0
var velocity = Vector3.ZERO
var curent_speed = 0
export var h_speed = 5
export var speed_delta = 5

func _input(event):
	if can_move:
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			mouse_is_pressed = event.pressed
		else:
			mouse_velocity = 0
		if (event is InputEventMouseMotion and mouse_is_pressed) or (event is InputEventScreenDrag and mouse_is_pressed):
				mouse_velocity = event.relative[0]

func _process(delta):
	if can_move:
		if abs(mouse_velocity) < 3:
			decrease_h_spead(delta)
		else:
			if abs(mouse_velocity) > 0:
				curent_speed = min(curent_speed+speed_delta*delta, h_speed*delta)
			if mouse_velocity > 0:
				velocity.z = curent_speed
			elif mouse_velocity < 0:
				velocity.z = -curent_speed
		move(velocity)

func decrease_h_spead(delta):
	mouse_velocity = 0
	if abs(velocity.z) > 0.3:
		if velocity.z > 0:
			velocity.z -= speed_delta*delta
		else:
			velocity.z += speed_delta*delta
	else:
		velocity.z = 0
		
func move(velocity):
	translation += velocity
