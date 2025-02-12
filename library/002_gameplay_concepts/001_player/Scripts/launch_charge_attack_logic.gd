extends Node
class_name ChargedAttackLogic

@export_multiline var Summary : String

@export var mira_game_master : MiraGameMaster

#----------------------------------
## REFERENCES
#Nodes
@export var animation_tree : AnimationTree

#-----------------
#StateMachine
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

#----------------------------------
func _ready() -> void:
	mira_game_master.player_use_charged_attack.connect(launch_charge_attack_animation)
	

#----------------------------------

func launch_charge_attack_animation() -> void : 
	base_state_machine.travel("Attack_Charge")
