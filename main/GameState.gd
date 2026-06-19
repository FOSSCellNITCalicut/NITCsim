extends Node

var save_data = null
const SAVE_PATH = "user://savegame.json"

var is_game_active := false
var is_paused := false
var current_pause_ui = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(true)

func save_game(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Saving game...")
	else:
		push_error("Failed to save game")


func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):

		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)

		if file:
			var json_string = file.get_as_text()
			file.close()

			var json = JSON.new()

			if json.parse(json_string) == OK:
				save_data = json.data

				is_game_active = true
				is_paused = false

				get_tree().change_scene_to_file(save_data["scene"])

	else:
		print("No save file found")

#start menu functions

func start_new_game(start_ui):
	is_game_active = true

	if start_ui:
		start_ui.visible = false

	print("New Game Started")


func setup_start_ui(start_ui):
	print("setup_start_ui is called")

	if start_ui == null:
		print("start_ui os null")
		return



	var start_btn = start_ui.get_node_or_null("New_game_button")

	if start_btn and not start_btn.pressed.is_connected(_on_start_pressed):
		start_btn.pressed.connect(_on_start_pressed.bind(start_ui))

	var continue_btn = start_ui.get_node_or_null("Continue_button")

	if continue_btn and not continue_btn.pressed.is_connected(_on_continue_pressed):
		continue_btn.pressed.connect(_on_continue_pressed)
	
	var quit_btn = start_ui.get_node_or_null("Quitbutton")
	
	if quit_btn and not quit_btn.pressed.is_connected(_on_quit_pressed):
		quit_btn.pressed.connect(_on_quit_pressed)

func _on_start_pressed(start_ui):
	print("START BUTTON CLICKED")
	start_new_game(start_ui)


func _on_continue_pressed():
	print("CONTINUE BUTTON CLICKED")
	load_game()

func _on_quit_pressed():
	print("QUIT BUTTON CLICKED")
	get_tree().quit()



#pause menu functions

func toggle_pause(pause_ui):

	is_paused = !is_paused
	print("is_paused =", is_paused)
	get_tree().paused = is_paused

	if pause_ui:
		pause_ui.visible = is_paused


func handle_pause_input(pause_ui):

	if Input.is_action_just_pressed("ui_cancel"):
		print("ESC detected")
		toggle_pause(pause_ui)

func resume_game(pause_ui):

	is_paused = false

	get_tree().paused = false

	if pause_ui:
		pause_ui.visible = false


func quit_game():
	get_tree().quit()


func save_and_quit(position, current_dir):

	var data = {
		"scene": get_tree().current_scene.scene_file_path,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"direction": current_dir
	}

	save_game(data)

	get_tree().quit()


func setup_pause_ui(pause_ui, player):
	print("Pause_ui is called")
	current_pause_ui = pause_ui
	if pause_ui == null:
		return

	pause_ui.visible = false

	var quit_btn = pause_ui.get_node_or_null("Quitbutton")
	var save_btn = pause_ui.get_node_or_null("Savebutton")
	var cont_btn = pause_ui.get_node_or_null("Continuebutton")

	if quit_btn:
		quit_btn.pressed.connect(
			func(): quit_game()
		)

	if cont_btn:
		cont_btn.pressed.connect(
			func(): resume_game(pause_ui)
		)

	if save_btn:
		save_btn.pressed.connect(
			func():
				save_and_quit(
					player.position,
					player.current_dir
				)
)


func _process(_delta):

	if current_pause_ui:
		handle_pause_input(current_pause_ui)
