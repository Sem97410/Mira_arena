extends Node

class_name FightAnimationIndex

@onready var animation_index : int = 1


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#handle_animation_index()

func increment_index_animation() -> void : 

	animation_index+= 1
		
func clamp_animation_index() -> void : 
	if animation_index > 3 :
		animation_index = 1


func handle_animation_index() -> void :
	increment_index_animation()
	clamp_animation_index()
