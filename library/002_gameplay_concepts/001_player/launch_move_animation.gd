extends Node

@export var player : CharacterBody3D
@export var animation_tree : AnimationTree
@onready var movement_state_machine = animation_tree["parameters/MiraAnimation/MovementStateMachine/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_launch_player_movement_animation()


func _launch_player_movement_animation() -> void : 
	if player.velocity.length() >= 0 :
		movement_state_machine.travel("MovementBlendTree")
