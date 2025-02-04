extends Node

class_name LaunchAttackAnimationScript

@export_multiline var Summary : String

#----------------------------------
## REFERENCES
#Nodes
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer

#-----------
#Scripts
@export var index_animation_script : FightAnimationIndex

#----------------------------------
#StateMachine
@onready var base_state_machine = animation_tree["parameters/MiraAnimations/playback"]


#----------------------------------
#State
@onready var is_attacking : bool = false

#----------------------------------

#Latence max between two attack

@onready var base_combo_window_length : float = 1.0
@onready var current_combo_windo_length : float = 0


func _process(delta: float) -> void:
	launch_light_attack()
	


func launch_light_attack() -> void : 
	
	if Input.is_action_just_pressed("light_attack"):
		
		index_animation_script.handle_animation_index()
		index_animation_script.launch_countdown()

		
		base_state_machine.travel("Combo_" + str(index_animation_script.animation_index))
		
