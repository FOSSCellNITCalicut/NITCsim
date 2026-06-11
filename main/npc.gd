extends CharacterBody2D

@export var npc_name := "Campus Guide"
@export var idle_animation := "front_idle"
@export_multiline var dialogue_lines: PackedStringArray = [
	"Welcome to NITC!",
	"Explore the campus and visit the academic blocks.",
]

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $InteractArea


func _ready() -> void:
	$NameLabel.text = npc_name
	_apply_player_visual()
	anim.play(idle_animation)
	interact_area.body_entered.connect(_on_interact_area_body_entered)
	interact_area.body_exited.connect(_on_interact_area_body_exited)


func _apply_player_visual() -> void:
	var player_template: Node = preload("res://player.tscn").instantiate()
	var player_anim: AnimatedSprite2D = player_template.get_node("AnimatedSprite2D")
	anim.sprite_frames = player_anim.sprite_frames
	anim.scale = player_anim.scale
	anim.position = Vector2(0, -6)
	player_template.free()


func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.has_method("offer_interaction"):
		body.offer_interaction(self, "Press E to talk to %s" % npc_name)


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.has_method("clear_interaction"):
		body.clear_interaction(self)


func interact(_player: Node) -> void:
	DialogueBox.start_dialogue(npc_name, dialogue_lines)
