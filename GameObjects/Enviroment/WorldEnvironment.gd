extends WorldEnvironment

export var rotation_speed = 1.0

func _physics_process(delta):
	environment.background_sky_rotation_degrees.y += rotation_speed*delta
