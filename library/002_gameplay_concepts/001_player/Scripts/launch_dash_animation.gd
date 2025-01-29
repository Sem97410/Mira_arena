extends Node

@export_multiline var Summary : String

#----------------------------------
## REFERENCES
#Nodes
@export var animation_tree : AnimationTree

#-----------------
#StateMachine
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

#----------------------------------
func _process(delta: float) -> void:
	launch_dash_animation()
	
#----------------------------------
func launch_dash_animation() -> void : 
	if Input.is_action_just_pressed("dash"):
		base_state_machine.travel("Dash")
