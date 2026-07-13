extends Area2D

@export var building_name := "Academic Block"
@export_multiline var building_description := "Main academic building on campus."
@export var interior_scene := "res://inside.tscn"
@export var exit_spawn_offset := Vector2(0, 28)


func _on_body_entered(body: Node2D) -> void:
	if not _is_player(body):
		return
	var prompt := "Press E to enter %s" % building_name
	if body.has_method("offer_interaction"):
		body.offer_interaction(self, prompt)


func _on_body_exited(body: Node2D) -> void:
	if not _is_player(body):
		return
	if body.has_method("clear_interaction"):
		body.clear_interaction(self)


func interact(player: Node2D) -> void:
	var exit_pos := player.global_position + exit_spawn_offset
	GameState.set_return_from_building(exit_pos, building_name)
	get_tree().change_scene_to_file(interior_scene)


func _is_player(body: Node2D) -> bool:
	return body.has_method("offer_interaction")
