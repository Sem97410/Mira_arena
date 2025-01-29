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
	if Input.is_action_just_pressed("charge_attack"):
		launch_charge_attack_animation()
		
		
#----------------------------------

func launch_charge_attack_animation() -> void : 
	base_state_machine.travel("Attack_Charge")
