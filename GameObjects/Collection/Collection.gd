extends Spatial


var collection = []
var start
var current_place = 14

func add_to_collection(item):
	setup_sprite(item.frames, item.animation)

func setup_sprite(frames, animation):
	var new_sprite = AnimatedSprite3D.new()
	new_sprite.translation = Vector3(current_place, 0.5, 0)
	new_sprite.scale = Vector3(0.5, 0.5, 0.5)
	new_sprite.frames = frames
	new_sprite.animation = animation
	new_sprite.playing = true
	add_child(new_sprite)
	current_place -= 0.8

func save():
	var save_dict = {
		"name": get_path()
	}
	for i in range(len(get_children())):
		if get_child(i) is AnimatedSprite3D:
			save_dict[i] = get_child(i).animation

	return save_dict

func to_load(save_dict):
	for key in save_dict:
		if key == "name":
			continue
		setup_sprite(load("res://Assets/Textures/Skins/Player.tres"), save_dict[key])
		
