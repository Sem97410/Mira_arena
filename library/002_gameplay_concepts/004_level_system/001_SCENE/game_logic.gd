extends Node



@export var player_body : CharacterBody3D # référence du player

func _process(delta: float) -> void:
	# méthode pour 
	get_tree().call_group("slime_comportement_function","_update_target_position",player_body.global_position)
	
