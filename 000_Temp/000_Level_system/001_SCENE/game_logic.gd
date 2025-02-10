extends Node



@export var player_body : PlayerPawn

func _physics_process(delta: float) -> void:
	get_tree().call_group("slime_comportement_function","_update_target_position",player_body.global_position)
	
