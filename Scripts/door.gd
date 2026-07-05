extends Area2D
@export var target_scene: String = ""
@export var spawn_point_name: String = ""  

var player_in_range := false
var _prompt: InteractPrompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_prompt = InteractPrompt.new()
	_prompt.position = Vector2(-14, -60)
	_prompt.visible = false
	add_child(_prompt)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		_prompt.set_visible_animated(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		_prompt.set_visible_animated(false)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		GameState.next_spawn_point = spawn_point_name
		get_tree().change_scene_to_file(target_scene)
