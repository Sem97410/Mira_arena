extends Node

class_name LerpLogic

@export var cube : RigidBody3D
@export var target1 : Node3D
@export var target2 : Node3D
@onready var transition_speed : float = 0.01
@onready var can_move : bool = false
@export var tween_script : TweenLogic

@export var is_using_lerp : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	move_cube_to_target()


func move_cube_to_target() -> void : 
	if can_move && is_using_lerp:
		cube.position = lerp(cube.position, (target1.position - Vector3(0, 2, 0 )), transition_speed)
		print("Move with lerp")
	elif not can_move && is_using_lerp :
		cube.position = lerp(cube.position, (target2.position - Vector3(0, 2, 0 )), transition_speed)
		print("Move with lerp")


		
		


func _on_lerp_movement_button_pressed() -> void:
	manage_button_turn_logic()
	can_move = not can_move 

func manage_button_turn_logic() -> void : 
	is_using_lerp = true 
	tween_script.is_using_tween = false
