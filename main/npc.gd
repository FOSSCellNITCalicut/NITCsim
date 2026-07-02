extends CharacterBody2D

@export var npc_name := "Campus Guide"
@export var idle_animation := "front_idle"
@export var dialog_file: String = ""

var _dialogue_lines: PackedStringArray = []

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interact_area: Area2D = $InteractArea


func _ready() -> void:
	$NameLabel.text = npc_name
	_apply_player_visual()
	anim.play(idle_animation)
	interact_area.body_entered.connect(_on_interact_area_body_entered)
	interact_area.body_exited.connect(_on_interact_area_body_exited)
	_load_dialogue()


func _load_dialogue() -> void:
	if dialog_file.is_empty():
		_dialogue_lines = ["..."]
		return
	var file := FileAccess.open(dialog_file, FileAccess.READ)
	if not file:
		printerr("NPC: Could not open dialog file: ", dialog_file)
		_dialogue_lines = ["..."]
		return
	var json_str := file.get_as_text()
	file.close()
	var json := JSON.new()
	var err := json.parse(json_str)
	if err != OK:
		printerr("NPC: Failed to parse dialog file: ", dialog_file)
		_dialogue_lines = ["..."]
		return
	var data := json.data as Dictionary
	if not data or not data.has("lines"):
		printerr("NPC: Missing 'lines' in dialog file: ", dialog_file)
		_dialogue_lines = ["..."]
		return
	_dialogue_lines = PackedStringArray(data["lines"])


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


func interact(player: Node) -> void:
	if not is_instance_valid(player):
		return
	DialogueBox.start_dialogue(npc_name, _dialogue_lines)
	# Wait for dialog to close, then re-offer interaction next frame
	await DialogueBox.dialogue_closed
	await get_tree().process_frame
	if is_instance_valid(player) and player.has_method("offer_interaction"):
		player.offer_interaction(self, "Press E to talk to %s" % npc_name)
