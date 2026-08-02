extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_at_building_exit"):
		body.set_at_building_exit(true)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("set_at_building_exit"):
		body.set_at_building_exit(false)
