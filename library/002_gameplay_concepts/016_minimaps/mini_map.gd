extends Control

@export var player : CharacterBody3D
@export var minimap_camera : Camera3D

func _process(delta: float) -> void:
	minimap_camera.global_position = player.global_position + Vector3.UP * 5
