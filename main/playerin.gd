extends CharacterBody2D

@onready var interact_label: Label = $Label
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

const SPEED = 100

var current_dir := "down"
var can_interact := false
var _interact_target: Node = null


func _ready() -> void:
	interact_label.visible = false
	reset_for_interior_spawn()


func reset_for_interior_spawn() -> void:
	current_dir = "down"
	velocity = Vector2.ZERO
	if anim:
		anim.play("front_idle")
	if camera:
		camera.make_current()
		camera.reset_smoothing()
		camera.force_update_scroll()


func _physics_process(_delta: float) -> void:
	if DialogueBox.is_blocking():
		velocity = Vector2.ZERO
		play_anim(false)
		move_and_slide()
		return

	var input_dir := Vector2(
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


func _process(_delta: float) -> void:
	if DialogueBox.is_open():
		return
	if can_interact and Input.is_action_just_pressed("interact"):
		_trigger_interaction()


func _trigger_interaction() -> void:
	interact_label.visible = false
	can_interact = false
	var target := _interact_target
	_interact_target = null
	if target and target.has_method("interact"):
		target.interact(self)


func offer_interaction(target: Node, prompt: String) -> void:
	_interact_target = target
	interact_label.text = prompt
	can_interact = true
	interact_label.visible = true


func clear_interaction(target: Node) -> void:
	if _interact_target == target:
		_interact_target = null
		can_interact = false
		interact_label.visible = false


func show_interact_label() -> void:
	offer_interaction(null, "Press E to interact")


func hide_interact_label() -> void:
	clear_interaction(null)


func play_anim(moving: bool) -> void:
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
