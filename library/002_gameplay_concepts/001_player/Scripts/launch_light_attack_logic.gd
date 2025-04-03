extends Node

class_name LightAttackAnimationScript

@export_multiline var Summary : String

#----------------------------------
## REFERENCES
#Nodes
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer



#-----------
#Scripts
@export var mira_game_master : MiraGameMaster
@export var index_animation_script : FightAnimationIndex

#----------------------------------
#StateMachine
@onready var base_state_machine = animation_tree["parameters/MiraAnimations/playback"]

#----------------------------------
#State
@onready var is_attacking : bool = false

#----------------------------------
#Latence max between two attack

@onready var base_combo_window_length : float = 1.5
@onready var current_combo_windo_length : float = 0

#----------------------------------
func _ready() -> void:
	mira_game_master.player_use_light_attack.connect(launch_light_attack)

#func _process(delta: float) -> void:
	
	#if Input.is_action_just_pressed("light_attack"):
	#
		#launch_light_attack()
	#if Input.is_action_just_pressed("Debug_2") : 
		#print("Debug 2")
		#base_state_machine.travel("Attack_Charge")
	#else: 
		#base_state_machine.stop()

func launch_light_attack() -> void : 

	var current_index = index_animation_script.handle_animation_index()

	index_animation_script.launch_countdown()
	#print("LightAttack index is : ", current_index)

	base_state_machine.travel("Combo" + str(current_index)+"BlendTree")
	#print("Combo" + str(current_index),"BlendTree")
	
