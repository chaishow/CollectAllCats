extends KinematicBody

onready var skin_container = $AnimatedSprite3D

var Estimate = preload("EstimateLabel/EstimateLabel.tscn")

var start_position = Vector3(0, 0.15, 0.5)
var start_score = 0
var start_level=1
var score = 0
var max_level = 22
var level = 1

var can_move = false
var no_negative= false


export var v_speed = 2
export var h_speed = 1.8
export var speed_delta = 5
var curent_speed = 0
var velocity = Vector3.ZERO


var mouse_is_pressed
var mouse_velocity = 0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal score_changed(score)
signal player_reseted()
signal level_changed(level)




func _ready():
	change_skin(level)
	velocity.z = v_speed


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
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		if abs(mouse_velocity) < 3:
			decrease_h_spead(delta)
		else:
			if abs(mouse_velocity) > 0:
				curent_speed = min(curent_speed+speed_delta, h_speed)
			if mouse_velocity > 0:
				velocity.x = -curent_speed
			elif mouse_velocity < 0:
				velocity.x = curent_speed
		
		move_and_slide(velocity, Vector3(0,1,0))

func decrease_h_spead(delta):
	mouse_velocity = 0
	if abs(velocity.x) > 0.3:
		if velocity.x > 0:
			velocity.x -= speed_delta*delta
		else:
			velocity.x += speed_delta*delta
	else:
		velocity.x = 0

func increase_score(score):
	var old_score = self.score
	if not no_negative:
		if score + self.score > 0:
			set_score(self.score+score)
		else:
			set_score(0)
	else:
		score=abs(score)
		set_score(self.score+score)
	if old_score < self.score:
		make_estimate(1)
	elif old_score > self.score:
		make_estimate(-1)

func multiply_score(coef):
	var old_score = self.score
	set_score(self.score*coef)
	if old_score < self.score:
		make_estimate(1)
	elif old_score > self.score:
		make_estimate(-1)


func set_score(score):
	score = stepify(score, 0.01)
	self.score = score
	emit_signal("score_changed", self.score)

func set_start_score(score):
	self.start_score += score
	set_score(start_score)
	
func set_level(level):
	if level>=1 and level <= max_level:
		self.level=level
	elif level < 1:
		self.level=1
	elif level > max_level:
		self.level = max_level
	emit_signal("level_changed", level)

func reset():
	global_translation = start_position
	set_level(start_level)
	emit_signal("player_reseted")
	set_score(start_score)
	change_skin(level)
	no_negative=false
	

func change_skin(skin):
	skin_container.play(str(level))


func make_estimate(score):
	var new_estimate = Estimate.instance()
	$AudioStreamPlayer.stop()
	if score >= 0:
		$AudioStreamPlayer.stream = $AudioStreamPlayer.good_reaction
		$Particles.process_material.set_color('00ffff')
		new_estimate.text = new_estimate.good_estimates[randi()%len(new_estimate.good_estimates)]
	else:
		$AudioStreamPlayer.stream = $AudioStreamPlayer.bad_reaction
		$Particles.process_material.set_color('ff0000')
		new_estimate.text = new_estimate.bad_estimates[randi()%len(new_estimate.bad_estimates)]
	new_estimate.translation = Vector3(0, 0.55, 0.25)
	add_child(new_estimate)
	$Particles.emitting = true
	$AudioStreamPlayer.play()

func die():
	queue_free()

func save():
	var save_dict = {
		"name": get_path(),
		"score": score,
		"start_score" : start_score,
		"level": level,
		"start_level" : start_level,
		
		}
	return save_dict

func to_load(save_dict):
	set_start_score(save_dict['start_score'])
	set_score(save_dict["score"])
	set_level(save_dict["level"])
	for key in save_dict:
		if key == "name":
			continue
		set(key, save_dict[key])
	
