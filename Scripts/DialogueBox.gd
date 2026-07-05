extends CanvasLayer

signal dialogue_started
signal dialogue_finished

var _panel: PanelContainer
var _name_label: Label
var _text_label: RichTextLabel
var _prompt_label: Label

var _lines: Array = []
var _line_index: int = 0
var _speaker: String = ""
var _is_typing: bool = false
var _full_text: String = ""
var _char_index: int = 0
var _type_speed: float = 0.02
var _type_timer: float = 0.0

var is_active: bool = false


func _ready() -> void:
	layer = 100
	_build_ui()
	visible = false
	set_process(false)


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_panel.anchor_left = 0.05
	_panel.anchor_right = 0.95
	_panel.anchor_top = 0.72
	_panel.anchor_bottom = 0.95
	add_child(_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	margin.add_child(vbox)

	_name_label = Label.new()
	_name_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(_name_label)

	_text_label = RichTextLabel.new()
	_text_label.fit_content = true
	_text_label.scroll_active = false
	_text_label.custom_minimum_size = Vector2(0, 60)
	_text_label.add_theme_font_size_override("normal_font_size", 18)
	vbox.add_child(_text_label)

	_prompt_label = Label.new()
	_prompt_label.text = "\u25bc press E"
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_prompt_label.modulate = Color(1, 1, 1, 0.6)
	vbox.add_child(_prompt_label)


func start(speaker: String, lines: Array) -> void:
	if lines.is_empty():
		return
	_speaker = speaker
	_lines = lines
	_line_index = 0
	is_active = true
	visible = true
	dialogue_started.emit()
	_show_line(_lines[_line_index])


func _show_line(line: String) -> void:
	_name_label.text = _speaker
	_full_text = str(line)
	_char_index = 0
	_text_label.text = ""
	_is_typing = true
	_prompt_label.visible = false
	set_process(true)


func _process(delta: float) -> void:
	if _is_typing:
		_type_timer += delta
		if _type_timer >= _type_speed:
			_type_timer = 0.0
			_char_index += 1
			_text_label.text = _full_text.substr(0, _char_index)
			if _char_index >= _full_text.length():
				_is_typing = false
				_prompt_label.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		_advance()
		get_viewport().set_input_as_handled()


func _advance() -> void:
	if _is_typing:
		# Skip the typewriter effect, show the full line immediately.
		_is_typing = false
		_char_index = _full_text.length()
		_text_label.text = _full_text
		_prompt_label.visible = true
		return
	_line_index += 1
	if _line_index >= _lines.size():
		_end_dialogue()
	else:
		_show_line(_lines[_line_index])


func _end_dialogue() -> void:
	is_active = false
	visible = false
	set_process(false)
	dialogue_finished.emit()
