extends Node

@export var camera_target : Node3D
@export var player_target : Node3D


@export var camera_follow_delay : float = 0.08



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#camera_target.position = lerp(camera_target.position, player_target.position, camera_follow_delay)
