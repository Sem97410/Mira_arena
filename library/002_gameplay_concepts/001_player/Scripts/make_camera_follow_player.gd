extends Node

@export var camera_controller : Node3D
@export var player : CharacterBody3D
@export var camera_follow_strength : float = 0.03


func _physics_process(delta: float) -> void:
	make_camera_follow_player()

func make_camera_follow_player() -> void : 
	camera_controller.position = lerp(camera_controller.position, player.position, camera_follow_strength )
