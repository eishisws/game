extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 2500.0
@export var friction: float = 1200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0
@export var max_jumps: int = 2        

@export var coyote_time: float = 0.12  
@export var jump_buffer_time: float = 0.12  

@export var short_hop_multiplier: float = 0.5  

@export var has_key_card: bool = false

func give_key_card() -> void:
	has_key_card = true

var jumps_left: int = max_jumps
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false


func _physics_process(delta: float) -> void:
	# --- Gravity ---
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = max_jumps
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	var can_coyote_jump := coyote_timer > 0.0 and jumps_left == max_jumps
	if jump_buffer_timer > 0.0 and (can_coyote_jump or jumps_left > 0):
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		jumps_left -= 1

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= short_hop_multiplier

	move_and_slide()

	was_on_floor = is_on_floor()
