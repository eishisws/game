extends Area2D
class_name NpcInteraction

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = ["..."]

var _player_in_range: bool = false
var _prompt: InteractPrompt
var _is_talking: bool = false

@onready var _talk_sound: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_prompt = InteractPrompt.new()
	_prompt.position = Vector2(-14, -60)
	_prompt.visible = false
	add_child(_prompt)

	if _talk_sound:
		_talk_sound.autoplay = false
		_talk_sound.finished.connect(_on_talk_sound_finished)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		_prompt.set_visible_animated(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		_prompt.set_visible_animated(false)

func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not DialogueBox.is_active and event.is_action_pressed("interact"):
		DialogueBox.typing_started.connect(start_talking)
		DialogueBox.typing_stopped.connect(stop_talking)
		DialogueBox.dialogue_finished.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)
		DialogueBox.start(npc_name, get_dialogue_lines())
		get_viewport().set_input_as_handled()
 
func _on_dialogue_finished() -> void:
	stop_talking()
	if DialogueBox.typing_started.is_connected(start_talking):
		DialogueBox.typing_started.disconnect(start_talking)
	if DialogueBox.typing_stopped.is_connected(stop_talking):
		DialogueBox.typing_stopped.disconnect(stop_talking)

func get_dialogue_lines() -> Array:
	return dialogue_lines

func start_talking() -> void:
	if not _talk_sound:
		return
	_is_talking = true
	_talk_sound.pitch_scale = randf_range(0.85, 1.15)
	_talk_sound.play()

func stop_talking() -> void:
	_is_talking = false
	if _talk_sound:
		_talk_sound.stop()

func _on_talk_sound_finished() -> void:
	if _is_talking:
		_talk_sound.pitch_scale = randf_range(0.85, 1.15)
		_talk_sound.play()
