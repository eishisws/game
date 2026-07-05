extends Area2D

@export var target_scene: String = ""
@export var spawn_point_name: String = ""

var isClosed: bool = true
var player_in_range := false
var player_ref: CharacterBody2D = null

@onready var left_door: MeshInstance2D = $MeshInstance2D
@onready var right_door: MeshInstance2D = $MeshInstance2D2

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
		player_ref = body
		if isClosed and player_ref.has_key_card:
			_prompt.set_visible_animated(true)
		elif not isClosed:
			_prompt.set_visible_animated(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null
		_prompt.set_visible_animated(false)

func _process(_delta: float) -> void:
	if not player_in_range or not Input.is_action_just_pressed("interact"):
		return

	if isClosed:
		open_doors()
	else:
		enter_elevator()

func open_doors() -> void:
	if not player_ref or not player_ref.has_key_card:
		return

	isClosed = false
	_prompt.set_visible_animated(false)

	var tween := create_tween()
	tween.set_parallel(true)

	var t1 := tween.tween_property(left_door, "position:x", left_door.position.x - 70, 0.6)
	t1.set_trans(Tween.TRANS_SINE)
	t1.set_ease(Tween.EASE_OUT)

	var t2 := tween.tween_property(right_door, "position:x", right_door.position.x + 70, 0.6)
	t2.set_trans(Tween.TRANS_SINE)
	t2.set_ease(Tween.EASE_OUT)

	tween.finished.connect(_on_doors_opened)

func _on_doors_opened() -> void:
	_prompt.set_visible_animated(true)

func enter_elevator() -> void:
	GameState.next_spawn_point = spawn_point_name
	get_tree().change_scene_to_file(target_scene)
