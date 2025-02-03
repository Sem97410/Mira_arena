extends Node

@export var player : CharacterBody3D

## Create a comment

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
