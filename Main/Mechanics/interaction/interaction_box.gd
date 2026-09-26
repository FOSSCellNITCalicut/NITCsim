extends Area2D
class_name InteractionBox


# Supports either an exported .tscn file or a PackedScene resource
@export_file("*.tscn") var target_scene_path: String = ""
@export var target_scene_packed: PackedScene

@export var door_name : String = ""

func _on_body_entered(body: Player) -> void:
	
	var target_door := door_name
	
	body.door_used = target_door
	
	if target_scene_packed:
		WorldManager.change_scene(target_scene_packed,target_door)
	else:
		WorldManager.change_scene(target_scene_path,target_door)
