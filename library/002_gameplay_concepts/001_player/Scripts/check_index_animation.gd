extends Node

class_name FightAnimationIndex

@onready var animation_index : int = 1


func increment_index_animation() -> void : 

	animation_index+= 1
		
func clamp_animation_index() -> void : 
	if animation_index > 3 :
		animation_index = 1


func handle_animation_index() -> void :
	increment_index_animation()
	clamp_animation_index()
