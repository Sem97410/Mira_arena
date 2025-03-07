extends Area3D

@export var respawn_position : Vector3

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.global_position = respawn_position
	
