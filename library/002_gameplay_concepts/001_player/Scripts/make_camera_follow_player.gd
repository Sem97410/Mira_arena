extends Node
class_name CameraBehavior

@export var camera_controller : Node3D
@export var player : CharacterBody3D
@export var target_in_front_player : Node3D
@export var camera_follow_strength : float = 0.03
@export var current_camera_offset : Vector3
@onready var base_camera_offset: Vector3 = Vector3(0, 0, 0) # ← Nouvel offset configurable
@onready var death_camera_offset : Vector3 = Vector3(0,-3.0,-3.0)

@onready var current_target_position = player.global_position

func _ready() -> void:
	current_camera_offset = base_camera_offset
	
func _physics_process(_delta: float) -> void:
	make_camera_follow_player()

	if player.velocity.length() <= 0.25:
		current_target_position = player.global_position
	elif player.velocity.length() > 0.25 and player.is_alive:
		current_target_position = target_in_front_player.global_position
	
	if player.is_alive == false:
		current_target_position = player.global_position

func make_camera_follow_player() -> void:
	var target_position_with_offset = current_target_position + current_camera_offset
	camera_controller.global_position = lerp(camera_controller.global_position,target_position_with_offset,camera_follow_strength)
