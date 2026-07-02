extends CanvasLayer

signal dialogue_closed

var _lines: PackedStringArray = []
var _speaker := ""
var _index := 0
var _open := false

@onready var _panel: PanelContainer = $Panel
@onready var _speaker_label: Label = $Panel/Margin/VBox/Speaker
@onready var _text_label: Label = $Panel/Margin/VBox/Text
@onready var _hint_label: Label = $Panel/Margin/VBox/Hint


func _ready() -> void:
	_panel.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func is_open() -> bool:
	return _open


func is_blocking() -> bool:
	return _open


func start_dialogue(speaker: String, lines: PackedStringArray) -> void:
	if lines.is_empty():
		return
	_speaker = speaker
	_lines = lines
	_index = 0
	_open = true
	_panel.visible = true
	_show_line()


func _show_line() -> void:
	_speaker_label.text = _speaker
	_text_label.text = _lines[_index]
	_hint_label.text = "Press E to continue" if _index < _lines.size() - 1 else "Press E to close"


func _unhandled_input(event: InputEvent) -> void:
	if not _open:
		return
	if event.is_action_pressed("interact"):
		_advance()
		get_viewport().set_input_as_handled()


func _advance() -> void:
	if _index < _lines.size() - 1:
		_index += 1
		_show_line()
	else:
		_close()


func _close() -> void:
	_open = false
	_panel.visible = false
	_lines.clear()
	_speaker = ""
	dialogue_closed.emit()
