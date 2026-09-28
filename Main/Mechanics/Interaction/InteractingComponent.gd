extends Node2D

@onready var interact_label: Label = $InteractLabel

func _ready() -> void:
	interact_label.visible = false

func _on_interacting_range_body_entered(body: Node2D) -> void:
	interact_label.visible = true

func _on_interacting_range_body_exited(body: Node2D) -> void:
	interact_label.visible = false
