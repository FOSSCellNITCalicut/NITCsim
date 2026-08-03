extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var interact_label: Label = $Label
@onready var start_ui = $"../StartUI"
@onready var pause_ui = get_node_or_null("../PauseUI")

const SPEED = 100
var current_dir = "down"
var can_interact := false



func _ready():
	interact_label.visible = false

	GameState.setup_pause_ui(pause_ui, self)

	if GameState.save_data:
		position = Vector2(
			GameState.save_data.position.x,
			GameState.save_data.position.y
		)

		current_dir = GameState.save_data.direction
		GameState.is_game_active = true
		GameState.save_data = null

		if start_ui:
			start_ui.hide()

		if pause_ui:
			pause_ui.hide()

	else:
		if start_ui:
			GameState.is_game_active = false
			start_ui.show()
			GameState.setup_start_ui(start_ui)
		else:
			GameState.is_game_active = true

	call_deferred("_play_start_idle")
	return


func _play_start_idle():
	anim.play("front_idle")


func _physics_process(_delta):
	if not GameState.is_game_active:
		velocity = Vector2.ZERO
		if not anim.is_playing() or anim.animation != "front_idle":
			_play_start_idle()
		return
		
	if GameState.is_paused:
		velocity = Vector2.ZERO
		return
	
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_dir.length() > 0:
		if abs(input_dir.x) < 0.1 and input_dir.y != 0:
			current_dir = "down" if input_dir.y > 0 else "up"
		elif abs(input_dir.y) < 0.1 and input_dir.x != 0:
			current_dir = "right" if input_dir.x > 0 else "left"
		else:
			current_dir = "right" if input_dir.x > 0 else "left"
		
		velocity = input_dir.normalized() * SPEED
		play_anim(true)
	else:
		velocity = Vector2.ZERO
		play_anim(false)

	move_and_slide()

func _process(_delta):
	if not GameState.is_game_active:
		return
	if GameState.is_paused:
		return 
	if can_interact and Input.is_action_just_pressed("interact"):
		interact_label.visible = false
		can_interact = false
		get_tree().change_scene_to_file("res://inside.tscn")



func play_anim(moving: bool):
	match current_dir:
		"up":
			anim.flip_h = false
			anim.play("back_walk" if moving else "back_idle")
		"right":
			anim.flip_h = false
			anim.play("side_walk" if moving else "side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_walk" if moving else "side_idle")
		"down":
			anim.flip_h = false
			anim.play("front_walk" if moving else "front_idle")
		


func show_interact_label():
	can_interact = true
	interact_label.visible = true

func hide_interact_label():
	can_interact = false
	interact_label.visible = false
	
