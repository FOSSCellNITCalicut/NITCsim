extends Node

var return_position := Vector2.ZERO
var current_building := ""

func set_return_from_building(position: Vector2, building_name: String) -> void:
	return_position = position
	current_building = building_name

func consume_return_position() -> Vector2:
	var pos := return_position
	return_position = Vector2.ZERO
	return pos
