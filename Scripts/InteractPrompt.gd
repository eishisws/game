extends Control
class_name InteractPrompt

@export var key_text: String = "E"
@export var key_size: Vector2 = Vector2(28, 28)

var _key_panel: Panel
var _key_label: Label
var _tween: Tween


func _ready() -> void:
	custom_minimum_size = key_size
	size = key_size
	pivot_offset = key_size / 2.0 

	_key_panel = Panel.new()
	_key_panel.size = key_size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.14)
	style.border_color = Color(1, 1, 1, 0.9)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	_key_panel.add_theme_stylebox_override("panel", style)
	add_child(_key_panel)

	_key_label = Label.new()
	_key_label.text = key_text
	_key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_key_label.size = key_size
	_key_label.add_theme_font_size_override("font_size", 16)
	add_child(_key_label)

	_start_loop()


func _start_loop() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_loops()  
	_tween.tween_property(self, "scale", Vector2(0.82, 0.82), 0.12).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.18).set_trans(Tween.TRANS_SINE)
	_tween.tween_interval(0.55)  


func set_visible_animated(value: bool) -> void:
	visible = value
	if value:
		scale = Vector2(1, 1)
		_start_loop()
	elif _tween:
		_tween.kill()
