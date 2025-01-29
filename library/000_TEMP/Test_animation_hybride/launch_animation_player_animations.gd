extends Node

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimation/playback"]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	launch_test_action()
	
func launch_test_action() -> void : 
	
	if Input.is_action_just_pressed("light_attack"):
		base_state_machine.travel("Combo_1")
		print("Launch light attack")

	elif Input.is_action_just_pressed("charge_attack"):
		base_state_machine.travel("Attack_Charge")
		print("Launch charge attack")
		
	elif  Input.is_action_just_pressed("movement_button"): 
		base_state_machine.travel("Dash")
		print("Launch movement")
