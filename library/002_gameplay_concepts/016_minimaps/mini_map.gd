extends Control

@export var player : CharacterBody3D
@export var minimap_camera : Camera3D
@export var close_camera_distance : float
@export var far_camera_distance : float
@onready var current_camera_distance : float = close_camera_distance
var is_far_distance := false


func _process(delta: float) -> void:
	minimap_camera.global_position = player.global_position + Vector3.UP * 5
	minimap_camera.size = current_camera_distance
	
	if Input.is_action_just_pressed("toggle_minimap"):
		toggle_minimap_camera_distance()

func toggle_minimap_camera_distance() -> void : 
	is_far_distance = not is_far_distance  # inverse l'état
	print("Use toggle minimap camera")

	if is_far_distance:
		current_camera_distance = far_camera_distance
	else:
		current_camera_distance = close_camera_distance
