extends Spatial


onready var anim_controller = $AnimationPlayer


func _on_finish_trigger_area_body_entered(body):
	if body.name == 'Player':
		anim_controller.play('ComeIn')

func reset():
	translation = Vector3(0, -5, -3)
