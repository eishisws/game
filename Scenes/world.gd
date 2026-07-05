extends Node2D 

func _ready() -> void:
	if GameState.next_spawn_point != "":
		var spawn := get_node_or_null(GameState.next_spawn_point)
		if spawn:
			$Player.global_position = spawn.global_position
		GameState.next_spawn_point = ""  
