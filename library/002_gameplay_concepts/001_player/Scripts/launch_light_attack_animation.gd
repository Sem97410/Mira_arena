extends Node

@export_multiline var Summary : String

@export var animation_tree : AnimationTree
@export var index_animation_script : FightAnimationIndex
@onready var base_state_machine = animation_tree["parameters/MiraAnimation/playback"]



func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("attack"):
		base_state_machine.travel("FightStateMachine/LightAttackStateMachine")
		launch_light_attack_animation()
		

		
func launch_light_attack_animation()->void : 
	print("Launch of the light attack")
	
	var current_index_number = index_animation_script.animation_index  #Update the current_index_number variable
	
	index_animation_script.handle_animation_index()  # Launch function that will increment and clamp the index animation number

	base_state_machine.travel("Combo_" + str(current_index_number)) # Launch travel 
	
	print("Current index number is : ", current_index_number)
	print("FightStateMachine/LightAttackStateMachine/Combo_" + str(current_index_number))
	
