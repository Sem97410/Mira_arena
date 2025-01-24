extends Node

class_name StateTransition

@export_multiline var Summary : String

@export var animation_tree : AnimationTree
@onready var base_state_machine = animation_tree["parameters/MiraAnimation/playback"]

@export var player_is_moving_script : PlayerMovementScript
@export var player_launch_attack_animation : LaunchAttackAnimationScript

@export var IsMoving : bool = true
@export var IsFighting : bool = false
@export var IsDealingWithHealth : bool = false





func _process(delta: float) -> void:
	if player_is_moving_script.player_is_moving : 
		print("The player is moving")
		base_state_machine.travel("MovementStateMachine")
		animation_tree.set("parameters/MiraAnimation/conditions/IsMoving", true)
		animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", false)
		animation_tree.set("parameters/MiraAnimation/conditions/IsDealingWithHealth", false)
	#elif player_launch_attack_animation.is :
		#print("Player is not moving")
		#animation_tree.set("parameters/MiraAnimation/conditions/IsMoving", false)
		#animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", false)
		#animation_tree.set("parameters/MiraAnimation/conditions/IsDealingWithHealth", false)
