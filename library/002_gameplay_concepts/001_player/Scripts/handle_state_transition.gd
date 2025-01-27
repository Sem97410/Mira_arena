extends Node

class_name StateTransition

@export_multiline var Summary : String

@export var animation_tree : AnimationTree

@onready var base_state_machine = animation_tree["parameters/MiraAnimation/playback"]
@onready var movement_state_machine = animation_tree["parameters/MiraAnimation/MovementStateMachine/playback"]
@onready var fight_state_machine = animation_tree["parameters/MiraAnimation/FightStateMachine/playback"]

@export var player_is_moving_script : PlayerMovementScript
@export var player_launch_attack_animation : LaunchAttackAnimationScript

@export var IsMoving : bool = true
@export var IsFighting : bool = false
@export var IsDealingWithHealth : bool = false



#func launch_
