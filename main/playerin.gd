extends CharacterBody2D
@onready var interact_label: Label = $Label
const SPEED = 100
var current_dir = "up"
var can_interact := false

@onready var anim = $AnimatedSprite2D






func _ready():
	print("Game Begin")
	call_deferred("_play_start_idle")
	interact_label.visible = false

func _play_start_idle():
	anim.play("front_idle")


func _physics_process(_delta):
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
	
