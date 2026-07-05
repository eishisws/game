extends Area2D
class_name NpcInteraction

@export var npc_name: String = "NPC"
@export var dialogue_lines: Array[String] = ["..."]

var _player_in_range: bool = false
var _prompt: InteractPrompt


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	_prompt = InteractPrompt.new()
	_prompt.position = Vector2(-14, -60)
	_prompt.visible = false
	add_child(_prompt)


func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name, " | in player group: ", body.is_in_group("player"))
	if body.is_in_group("player"):
		_player_in_range = true
		_prompt.set_visible_animated(true)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		_prompt.set_visible_animated(false)


func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and not DialogueBox.is_active and event.is_action_pressed("interact"):
		DialogueBox.start(npc_name, get_dialogue_lines())
		get_viewport().set_input_as_handled()


func get_dialogue_lines() -> Array:
	return dialogue_lines
