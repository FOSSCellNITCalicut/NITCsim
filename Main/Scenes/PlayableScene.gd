extends Node2D
class_name PlayableScene

@export var spawn_point: Marker2D 
var player : Player

func _ready() -> void:
	
	for child in get_children():
		if child is Player:
			player = child
			break
	
	if not player:
		player = Player.new()
		set_player_position()
		add_child(player)
	else:
		set_player_position()
	
	load_data()

func set_player_position(marker : Marker2D = spawn_point):
	if marker:
		player.global_position = marker.global_position

# functions to be changed for saving and loading scene data
func save_data():
	pass

func load_data():
	pass
