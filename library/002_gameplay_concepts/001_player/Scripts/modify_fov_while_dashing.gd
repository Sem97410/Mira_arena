extends Node

@export_multiline var Summary : String

@export var camera : Camera3D

@onready var base_FOV : float = 75.0

@onready var dash_FOV : float = 90.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#modify_fov_while_dashing()
	modify_fov_with_tween()
	
func modify_fov_while_dashing() -> void : 
	if Input.is_action_just_pressed("dash"):
		camera.fov = dash_FOV
		
		await get_tree().create_timer(0.5).timeout
		
		camera.fov = base_FOV

func modify_fov_with_tween() -> void : 
	if Input.is_action_just_pressed("dash"):
		var tween = create_tween()

		tween.tween_property(camera, "fov", dash_FOV, 0.1)
	
		await get_tree().create_timer(0.3).timeout
		
		var tween_back = get_tree().create_tween()
		tween_back.tween_property(camera, "fov", base_FOV, 0.1)

	
