extends Node2D

@onready var interact_label: Label = $InteractLabel

func _ready() -> void:
	interact_label.visible = false

func _on_interacting_rnage_body_entered(body: Player) -> void:
	interact_label.visible = true
	pass # Replace with function body.


func _on_interacting_rnage_body_exited(body: Player) -> void:
	interact_label.visible = false
	pass # Replace with function body.
