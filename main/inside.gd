extends Node2D


func _ready() -> void:
	_setup_ui()
	_spawn_player_at_entrance()


func _setup_ui() -> void:
	var title: Label = $InteriorUI/Title
	var subtitle: Label = $InteriorUI/Subtitle
	if GameState.current_building.is_empty():
		title.text = "Academic Block"
	else:
		title.text = GameState.current_building
	subtitle.text = "Reception and study hall — press E at the door to leave."


func _spawn_player_at_entrance() -> void:
	var player: CharacterBody2D = $player
	var entrance: Marker2D = $EntranceSpawn
	if player == null or entrance == null:
		return

	player.global_position = entrance.global_position

	if player.has_method("reset_for_interior_spawn"):
		player.reset_for_interior_spawn()

	var camera: Camera2D = player.get_node_or_null("Camera2D")
	if camera:
		camera.make_current()
		camera.reset_smoothing()
		camera.force_update_scroll()
