extends Node

@export var combo_signal : FightComboSignal

@export var animation_tree : AnimationTree
@onready var fight_state_machine  = animation_tree["parameters/FightStateMachine/playback"]

@onready var animation_index : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	combo_signal.chanel.connect(_launch_attack)

func _process(delta: float) -> void:
	_handle_animation_index()
	#_handle_animation_condition()

func _launch_attack() -> void :
	print("Attack button was pressed")
	print("animation_index = ", animation_index)
	
	var animation_to_launch : String = ("combo_" + str(animation_index))
	print(animation_to_launch)
	fight_state_machine.travel(animation_to_launch)
	animation_index += 1
	
func _handle_animation_index() -> void : 
	if animation_index > 3 :
		animation_index = 1

func _handle_animation_condition() -> void : 
	if animation_index == 1 :
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_1", true)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_2", false)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_3", false)
	elif animation_index == 2 :
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_2", true)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_1", false)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_3", false)
		
	elif animation_index == 3 :
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_3", true)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_1", false)
		animation_tree.set("parameters/FightStateMachine/conditions/is_combo_2", false)
		
		
## IDEA
# I need to had a signal that will control when you are able to transition from an animation
# to an other. 
