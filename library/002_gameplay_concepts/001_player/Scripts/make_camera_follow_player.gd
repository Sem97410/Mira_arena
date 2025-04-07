extends Node

@export var camera_controller : Node3D
@export var player : CharacterBody3D
@export var target_in_front_player : Node3D
@export var camera_follow_strength : float = 0.03


@onready var current_target_position = player.global_position

func _physics_process(_delta: float) -> void:
	make_camera_follow_player()


	
	if player.velocity.length() <= 0.25 :
		current_target_position = player.global_position
		#print("Current = player")
	else :
		current_target_position = target_in_front_player.global_position

		
func make_camera_follow_player() -> void : 
	camera_controller.global_position = lerp(camera_controller.global_position, current_target_position, camera_follow_strength)
