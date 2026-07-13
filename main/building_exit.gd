extends Area2D

@export var exterior_scene := "res://node_2d.tscn"


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("offer_interaction"):
		return
	body.offer_interaction(self, "Press E to exit building")


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("clear_interaction"):
		body.clear_interaction(self)


func interact(_player: Node) -> void:
	GameState.current_building = ""
	get_tree().change_scene_to_file(exterior_scene)
