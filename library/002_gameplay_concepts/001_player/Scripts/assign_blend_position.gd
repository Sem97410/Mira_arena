extends Node

@export var player : CharacterBody3D
@export var animation_tree : AnimationTree



		
func _physics_process(delta: float) -> void:

	animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/MovementBlendSpace/blend_position", player.velocity.length())

	

	
	
	
