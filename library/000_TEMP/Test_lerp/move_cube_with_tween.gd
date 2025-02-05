extends Node
class_name TweenLogic

@export var cube : CharacterBody3D
@export var target_1 : Node3D
@export var target_2 : Node3D
@export var lerp_script : LerpLogic
@onready var is_using_tween : bool = false
@onready var can_move : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	move_cube_to_target()
	
	
func _on_tween_movement_button_pressed() -> void:
	manage_button_turn_logic()
	

func manage_button_turn_logic() -> void : 
	is_using_tween = true
	lerp_script.is_using_lerp = false
	can_move = not can_move

func move_cube_to_target()-> void : 
	if can_move && is_using_tween : 
		var tween = create_tween()
		tween.tween_property(cube, "position" , (target_1.position - Vector3(0,2,0)), 1)
		print("Move with tween")
	elif is_using_tween : 
		var tween = create_tween()
		tween.tween_property(cube, "position" , (target_2.position - Vector3(0,2,0)), 1)
		print("Move with tween")
