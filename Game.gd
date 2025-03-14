extends Spatial


var gates = [preload("GameObjects/Gates/CancelNegativ.tscn"),
			preload("GameObjects/Gates/Gate.tscn"), 
			preload("GameObjects/Gates/CoupleGate.tscn"),
			preload("GameObjects/Gates/MovingGate.tscn"),
			preload("GameObjects/Gates/MultyplyGate.tscn")
			]

var level = 1
var have_no_negative_gates = false

var cache_player_can_move = false

signal player_finished(score)
signal level_changed(level)

onready var player = $Player
onready var gates_container = $Level/Gates
onready var restart_menu = $UI/RestartMenu
onready var start_menu = $UI/StartMenu
onready var finish = $Level/Road/Finish/Finish
onready var collection = $Collection
onready var collection_camera = $Camera
onready var main_camera = player.get_node("Camera")
onready var enviroment = $WorldEnvironment

func _input(event):
	if Input.is_action_just_pressed('ui_cancel'):
		pause()


func _ready():
	randomize()
	load_game()
	preset_start_state()
	

	

func create_gate(gate, g_position, level):
	var new_gate = gate.instance()
	new_gate.transform[3] = g_position
	new_gate.rotation.y = PI
	new_gate.level_coef = level
	if player.level > 6:
		new_gate.level_coef = level*pow(5,(stepify((player.level/2),1)-2))
	
		
	gates_container.add_child(new_gate)

func generate_gates():
	var new_g_position = 2
	var min_space = 1.6
	var max_space = 2.6
	var last_coord = 28
	while new_g_position+max_space < last_coord:
		var spawn_position = Vector3(0, 0, new_g_position)
		var index = randi()%len(gates)
		if have_no_negative_gates:
			index = randi()%(len(gates)-1)+1 
		if index == 0:
			have_no_negative_gates = true
			
		var gate = gates[index]
		create_gate(gate, spawn_position, level)
		var space = rand_range(min_space, max_space)
		new_g_position = min(new_g_position+space, last_coord)
		
func delete_gates():
	have_no_negative_gates = false
	for gate in gates_container.get_children():
		gate.queue_free()


func _on_FinishArea_body_entered(body):
	if body.name == "Player":
		emit_signal("player_finished", body.score)
		player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		restart_menu.show()

func start_new_game():
	player.can_move = true
	start_menu.hide()

func set_level(level):
	self.level = level
	emit_signal("level_changed", level)
	
func restart_game():
	set_level(level+1)
	player.reset()
	delete_gates()
	generate_gates()
	restart_menu.hide()
	start_menu.show()
	finish.reset()
	save_game()

func pause():
	cache_player_can_move = player.can_move
	$UI/PauseMenu.show()
	player.can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func resume():
	$UI/PauseMenu.hide()
	player.can_move = cache_player_can_move
	if player.can_move:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_resume_button_button_up():
	resume()

func _on_exit_button_button_up():
	get_tree().quit()


func _on_collect_button_button_up():
	collection.add_to_collection(player.skin_container)
	restart_game()


func _on_show_collection_button_button_up():
	collection_camera.current = true
	collection_camera.can_move = true
	start_menu.hide()
	$UI/ReturnButton.show()
	collection.pause_mode = PAUSE_MODE_INHERIT
	

func _on_return_button_button_up():
	$UI/ReturnButton.hide()
	collection_camera.can_move = false
	main_camera.current = true
	start_menu.show()
	collection.pause_mode = PAUSE_MODE_STOP



func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Saved")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.store_line(to_json(get_save()))
	save_game.close()


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return 

	var save_nodes = get_tree().get_nodes_in_group("Saved")

	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		if node_data["name"] == "Game":
			to_load(node_data)
		else:
			var node = get_node(node_data["name"])
			node.to_load(node_data)
	save_game.close()


func preset_start_state():
	collection_camera.current = false
	main_camera.current = true
	generate_gates()
	finish.reset()

func get_save():
	var save_dict = {
		"name" : "Game",
		"level" : level
	}
	
	return save_dict

func to_load(save_dict):
	set_level(save_dict["level"])
