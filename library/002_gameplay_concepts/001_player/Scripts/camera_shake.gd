extends Node

class_name CameraShake


@export var shake_fade : float = 10.0

var current_shake : float

@export var light_attack_shake : float = 0.1
@export var charged_attack_shake : float = 0.3
@export var death_shake : float = 0.3

@export var camera : Camera3D

var shake_strength : float = 0.0

func trigger_shake() -> void : 
	shake_strength = current_shake
	print(shake_strength)


func _process(delta: float) -> void:
	#print("Current camera shake is : ", current_shake)
		
	if shake_strength > 0: 
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		camera.transform.origin = Vector3(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength),0)
		#camera.offset = Vector3(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength),0)) # Regarder offset H offset et V offset
