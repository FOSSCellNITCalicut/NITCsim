extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var interact_label: Label = $Label
@onready var start_ui = $"../StartUI"
@onready var pause_ui = get_node_or_null("../PauseUI")

const SPEED = 100
var current_dir = "down"
var can_interact := false
var is_game_active := false 
var is_paused := false



func _ready():
	if start_ui and start_ui.has_node("StartButton"):
		var btn = start_ui.get_node("StartButton")
		btn.pressed.connect(_on_start_button_pressed)
		start_ui.visible = true # Show UI at start
	if pause_ui:
		pause_ui.visible = false
		var quit_btn = pause_ui.get_node("../PauseUI/Quitbutton")
		if quit_btn:
			quit_btn.pressed.connect(_on_quitbutton_pressed)
		var cont_btn = pause_ui.get_node_or_null("ContinueButton")
		if cont_btn:
			cont_btn.pressed.connect(_on_continuebutton_pressed)
	
	# Start in idle, NO movement allowed yet
	call_deferred("_play_start_idle")
	interact_label.visible = false
	is_game_active = false 

func _play_start_idle():
	anim.play("front_idle")


func _physics_process(_delta):
	# BLOCK all movement logic if game hasn't started
	if not is_game_active:
		velocity = Vector2.ZERO
		# Force idle animation while waiting
		if not anim.is_playing() or anim.animation != "front_idle":
			_play_start_idle()
		return
		
	if is_paused:
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
			current_dir = "right" if abs(input_dir.x) > abs(input_dir.y) else ("down" if input_dir.y > 0 else "up")
		
		velocity = input_dir.normalized() * SPEED
		play_anim(true)
	else:
		velocity = Vector2.ZERO
		play_anim(false)

	move_and_slide()

func _process(_delta):
	if not is_game_active:
		return
	if Input.is_action_just_pressed("ui_cancel"): # Usually ESC
		toggle_pause()
		return
	if is_paused:
		return # Stop interaction while paused
	if can_interact and Input.is_action_just_pressed("interact"):
		interact_label.visible = false
		can_interact = false
		get_tree().change_scene_to_file("res://inside.tscn")



func play_anim(moving: bool):
	match current_dir:
		"right":
			anim.flip_h = false
			anim.play("side_walk" if moving else "side_idle")
		"left":
			anim.flip_h = true
			anim.play("side_walk" if moving else "side_idle")
		"down":
			anim.flip_h = false
			anim.play("front_walk" if moving else "front_idle")
		"up":
			anim.flip_h = false
			anim.play("back_walk" if moving else "back_idle")


func show_interact_label():
	can_interact = true
	interact_label.visible = true

func hide_interact_label():
	can_interact = false
	interact_label.visible = false
	

func toggle_pause():
	is_paused = not is_paused
	get_tree().paused = is_paused # Freezes physics/process for the whole tree
	if pause_ui:
		pause_ui.visible = is_paused


func _on_quitbutton_pressed():
	get_tree().quit()
	print("Exiting...")


func _on_start_button_pressed():
	is_game_active = true 
	start_ui.visible = false # Hide the entire CanvasLayer
	print("Game Started - Controls Enabled")


func _on_continuebutton_pressed():
	is_paused = false
	get_tree().paused = false
	if pause_ui:
		pause_ui.visible = false
