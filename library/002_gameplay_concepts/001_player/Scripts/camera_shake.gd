extends Node

class_name CameraShake

@export var shake_fade: float = 10.0

var current_shake: float

@export var light_attack_shake: float = 0.1
@export var charged_attack_shake: float = 0.3
@export var death_shake: float = 0.3

@export var camera_position: Camera3D

var shake_strength: float = 0.0
var original_position: Vector3  # Stocke la position d'origine

func _ready() -> void:
	original_position = camera_position.transform.origin  # Sauvegarde la position de base

func trigger_shake() -> void:
	shake_strength = current_shake

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		camera_position.transform.origin = original_position + Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			0
		)
