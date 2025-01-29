extends Node

@export var player : Player

func _physics_process(delta: float) -> void:
	get_tree().call_group("updatePlayerPosition", "_update_target_position", player.global_transform.origin)
	
