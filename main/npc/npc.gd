extends Node2D

@export var dialog_lines: Array[String] = ["Hello there!", "Welcome to NITC!", "Good luck on your journey!"]

var current_dialog_index := 0
var player_ref = null

@onready var interact_label: Label = $InteractLabel
@onready var dialog_label: Label = $DialogLabel

func _ready():
	interact_label.visible = false
	dialog_label.visible = false

func _on_interaction_range_body_entered(body):
	if body.has_method("hide_interact_label"):
		body.current_interactable = self
		player_ref = body
		interact_label.visible = true

func _on_interaction_range_body_exited(body):
	if body.has_method("hide_interact_label"):
		body.current_interactable = null
	if player_ref == body:
		player_ref = null
	_reset()

func interact():
	if dialog_lines.is_empty():
		return
	
	if current_dialog_index >= dialog_lines.size():
		_reset()
		if player_ref:
			interact_label.visible = true
		return
	
	dialog_label.text = dialog_lines[current_dialog_index]
	dialog_label.visible = true
	interact_label.visible = false
	current_dialog_index += 1

func _reset():
	dialog_label.visible = false
	interact_label.visible = false
	current_dialog_index = 0
