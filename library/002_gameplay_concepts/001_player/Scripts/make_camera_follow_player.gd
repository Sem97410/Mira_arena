extends Node

@export var camera_controller : Node3D
@export var player : CharacterBody3D
@export var camera_follow_strength : float = 0.03

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	make_camera_follow_player()

func make_camera_follow_player() -> void : 
	camera_controller.position = lerp(camera_controller.position, player.position, camera_follow_strength )
