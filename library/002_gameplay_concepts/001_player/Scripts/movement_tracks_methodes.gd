extends Node

@export var movement_script : PlayerMovementScript


func enable_movement() -> void : 
	movement_script.can_move = true
	
func disable_movement() -> void : 
	movement_script.can_move = false
