extends Node

# --------------------------------------------------
## SUMMARY
#This Script will handle the animation speed base on the player velocity
# --------------------------------------------------

## REFERENCES
@export var player : CharacterBody3D
@export var animation_tree : AnimationTree

@export var base_animation_speed : float
@export var animation_speed : float


func _physics_process(_delta: float) -> void:
	pass
	#modify_animation_time_scale()
	


#Modify the speed of the TimeScale base on the player velocity.length() but only if this
#length() is between 0 and 0.5

func modify_animation_time_scale() -> void : 
	
	if player.velocity.length() >= 0.1 && player.velocity.length() <= 2:
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 1.5)
		
	else :
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 1)
