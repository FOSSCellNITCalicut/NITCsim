extends CharacterBody2D
@onready var interact_label: Label = $Label
@onready var anim = $AnimatedSprite2D
@onready var pause_ui = get_node_or_null("../PauseUI")

const SPEED = 100
var current_dir = "up"
var can_interact := false
var is_paused := false
var at_building_exit := false


func _ready() -> void:
	if pause_ui:
		pause_ui.visible = false
		var quit_btn = pause_ui.get_node("../PauseUI/Quitbutton")
		if quit_btn:
			quit_btn.pressed.connect(_on_quitbutton_pressed)
		var save_btn = pause_ui.get_node_or_null("../PauseUI/Savebutton")
		if save_btn:
			save_btn.pressed.connect(_on_save_button_pressed)
		var cont_btn = pause_ui.get_node_or_null("../PauseUI/Continuebutton")
		if cont_btn:
			cont_btn.pressed.connect(_on_continuebutton_pressed)

	current_dir = "up"
	interact_label.visible = false
	call_deferred("_play_start_idle")
	call_deferred("_check_exit_overlap")


func _check_exit_overlap() -> void:
	var exit_area = get_tree().current_scene.get_node_or_null("BuildingExit")
	if exit_area and exit_area.overlaps_body(self):
		set_at_building_exit(true)


func _play_start_idle() -> void:
	anim.play("front_idle")


func _physics_process(_delta: float) -> void:
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


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
		return
	if is_paused:
		return
	if can_interact and at_building_exit and Input.is_action_just_pressed("interact"):
		_exit_building()


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


func set_at_building_exit(value: bool) -> void:
	at_building_exit = value
	if value:
		show_interact_label()
	else:
		hide_interact_label()


func show_interact_label() -> void:
	can_interact = true
	interact_label.text = "Press E to exit"
	interact_label.visible = true


func hide_interact_label() -> void:
	can_interact = false
	interact_label.visible = false


func toggle_pause() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	if pause_ui:
		pause_ui.visible = is_paused


func _exit_building() -> void:
	interact_label.visible = false
	can_interact = false
	at_building_exit = false

	var return_pos = GameState.return_position
	if return_pos == null:
		return_pos = {"x": -230.0, "y": 155.0, "direction": "down"}

	GameState.save_data = {
		"position": {"x": return_pos.x, "y": return_pos.y},
		"direction": return_pos.get("direction", "down"),
		"can_interact": false,
	}
	GameState.return_position = null
	get_tree().change_scene_to_file("res://node_2d.tscn")


func _on_quitbutton_pressed() -> void:
	get_tree().quit()


func _on_continuebutton_pressed() -> void:
	is_paused = false
	get_tree().paused = false
	if pause_ui:
		pause_ui.visible = false


func _on_save_button_pressed() -> void:
	var data = {
		"scene": get_tree().current_scene.scene_file_path,
		"position": {"x": position.x, "y": position.y},
		"direction": current_dir,
		"can_interact": can_interact,
	}
	GameState.save_game(data)
	get_tree().quit()
