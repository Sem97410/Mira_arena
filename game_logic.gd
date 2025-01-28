extends Node
@export var player_position : player
@export var update_targetPosition : update_target_position

func _physics_process(delta: float) -> void:
	update_targetPosition._update_target_position(player_position.global_transform.origin)
	
