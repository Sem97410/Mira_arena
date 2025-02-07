extends Node

class_name FightAnimationIndex
#----------------------------------

## REFERENCES
#Values
@onready var animation_index : int = 1

@export var base_reset_countdown : float = 1.0
@onready var current_reset_countdown : float = 0.0

#----------------------------------

func _process(delta: float) -> void:
	#print("Animation Index is : ", animation_index)
	decrease_countdown(delta)
	handle_reset_animation_combo_index()

#----------------------------------
func handle_animation_index() -> int :
	var temp_index = animation_index
	
	increment_index_animation()
	clamp_animation_index()
	return temp_index
	
func increment_index_animation() -> void : 
	
	animation_index += 1
		
func clamp_animation_index() -> void : 
	
	if animation_index > 3 :
		reset_animation_index()


func reset_animation_index() :
	animation_index = 1
#----------------------------------
#----------------------------------
func decrease_countdown(delta : float) -> void :
	if current_reset_countdown > 0 :
		current_reset_countdown -= delta
		
#----------------------------------

func launch_countdown() -> void : 
	current_reset_countdown = base_reset_countdown
	
func handle_reset_animation_combo_index():
	if current_reset_countdown <= 0 :
		reset_animation_index()
