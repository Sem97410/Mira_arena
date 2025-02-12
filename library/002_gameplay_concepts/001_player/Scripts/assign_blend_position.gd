extends Node

@export var player : CharacterBody3D
@export var animation_tree : AnimationTree



		
func _physics_process(_delta: float) -> void:

	animation_tree.set("parameters/MiraAnimations/MovementBlendSpace/blend_position", player.velocity.length())

	

	
	
	
