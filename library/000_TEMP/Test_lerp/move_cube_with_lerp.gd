extends Node

@export var cube : CharacterBody3D

@export  var duration : float = 0.2
@export var dash_length : float

var start_position : Vector3
@onready var start_time : int = 0
var destination_target : Vector3 


func _physics_process(delta: float) -> void:

	move_cube_to_target(delta)

func move_cube_to_target(delta : float) -> void : 
	
	if start_time > 0 :
		
		var t : float =  ((float)(Time.get_ticks_msec() - start_time) / 1000.0) / duration
		
		var step : Vector3
		
		step = start_position.lerp(destination_target, t)
		#step = start_position + (target1.position - start_position) * t  ## Same than lerp()
		step -= cube.position
		
		var coll : KinematicCollision3D = cube.move_and_collide(step)
		
		#cube.velocity = step / delta
		#cube.move_and_slide()
		if t >= 1 or coll :
			start_time = 0
		


func _on_lerp_movement_button_pressed() -> void:

	start_position = cube.position
	start_time = Time.get_ticks_msec()
	destination_target = cube.position + cube.transform.basis.z * dash_length
	
