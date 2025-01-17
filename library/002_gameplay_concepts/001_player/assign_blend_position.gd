extends Node

@export var player : CharacterBody3D
@export var animation_tree : AnimationTree



func _physics_process(delta: float) -> void:

	animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/MovementBlendSpace/blend_position", player.velocity.length())
	
	modify_animation_time_scale()
	
	
	
# Modifier la vitesse du time scale en fonction de la velocité du joueur mais uniquement entre 0 et 0.5

func modify_animation_time_scale() -> void : 
	if player.velocity.length() >= 0.0:
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 2.5)
	else :
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 1)
