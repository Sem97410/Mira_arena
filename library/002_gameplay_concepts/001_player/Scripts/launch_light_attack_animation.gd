extends Node

class_name LaunchAttackAnimationScript

@export_multiline var Summary : String

#----------------------------------
## REFERENCES
#Nodes
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer

#-----------

@export var index_animation_script : FightAnimationIndex

#----------------------------------

@onready var base_state_machine = animation_tree["parameters/MiraAnimation/playback"]


#----------------------------------
#State
@onready var is_attacking : bool = false

#----------------------------------

#Latence max between two attack

@onready var base_combo_window_length : float = 1.0
@onready var current_combo_windo_length : float = 0





func _physics_process(delta: float) -> void:

	

	if Input.is_action_just_pressed("attack"):
				
		launch_light_attack_animation()
	
		
	

		
func launch_light_attack_animation()->void : 
	#print("Launch of the light attack")
	choose_the_animation()
	

	
	
#func create_latence_before_changing_state(delta : float) -> void:
	#
	#var animation_length = animation_player.current_animation_length
	#current_combo_windo_length = animation_length + base_combo_window_length  # 1 + 0.25 (durée animation)
	#
	#await  get_tree().create_timer(current_combo_windo_length).timeout
	#
	#if current_combo_windo_length <= 0 :
		#base_state_machine.travel("MovementStateMachine")
	
	
func decrease_animation_length(delta : float) -> void :
	current_combo_windo_length -= delta

func choose_the_animation() -> void : 
	var current_index_number = index_animation_script.animation_index  #Update the current_index_number variable
	
	index_animation_script.handle_animation_index()  # Launch function that will increment and clamp the index animation number

	animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", true)
	base_state_machine.travel("Combo_" + str(current_index_number)) # Launch travel 
	
	print("Is playing:", animation_player.is_playing())
	print("Current animation:", animation_player.current_animation)
	print("Animation progress:", animation_player.current_animation_position)
	
	animation_player.play("Combo_1")
