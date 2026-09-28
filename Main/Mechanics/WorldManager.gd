extends Node2D

@onready var scenes: Node2D = $Scenes

@export var start_scene : PackedScene = preload("res://Scenes/main_world.tscn")

func _ready() -> void:
	scenes = get_node_or_null("Scenes")
	if scenes == null:
		scenes = Node2D.new()
		scenes.name = "Scenes"
		add_child(scenes)

	change_scene(start_scene)

func change_scene(scene: Variant,door : String = "") -> void:
	# Resolve input into a PackedScene regardless of what was passed
	var packed_scene: PackedScene
	
	if scene is String:
		packed_scene = load(scene)
	elif scene is PackedScene:
		packed_scene = scene
	else:
		push_error("change_scene() expects a String path or a PackedScene, got: %s" % typeof(scene))
		return
	
	if packed_scene == null:
		push_error("Failed to load scene: %s" % scene)
		return
	
	# Free whatever is currently loaded
	
	
	if scenes.get_child_count() > 0:
		for child in scenes.get_children():
			child.queue_free()
		await get_tree().process_frame # wait to ensure deletion
	
	var new_scene = packed_scene.instantiate()
	scenes.add_child(new_scene)
	
	if new_scene is PlayableScene:
		if door == "":
			new_scene.set_player_position()
		else:
			var exit_point = new_scene.find_child(door,true,false)
			if exit_point is Marker2D:
				new_scene.set_player_position(exit_point)
			else:
				new_scene.set_player_position()
