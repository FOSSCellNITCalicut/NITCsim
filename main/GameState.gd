# GameState.gd
extends Node

var save_data = null
const SAVE_PATH = "user://savegame.json"

func save_game(data: Dictionary) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Saving game..")
	else:
		push_error("Failed to save game: " + str(FileAccess.get_open_error()))

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			if json.parse(json_string) == OK:
				save_data = json.data
				# Change to the saved scene
				get_tree().change_scene_to_file(save_data["scene"])
			else:
				push_error("Failed to parse save file")
	else:
		print("No save file found")   
