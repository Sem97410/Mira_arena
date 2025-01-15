extends Node
@export var animation_signal_resource_02 : AnimationSignalResource02

@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/StateMachine/StateMachine1/playback"]
@onready var transition_condition : bool = animation_tree["parameters/StateMachine/StateMachine1/conditions/isCombo2"]

@onready var isCombo2 : bool 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_signal_resource_02.channel.connect(_launch_animation_02)
	print("En ready la variable est : ",transition_condition)

func _launch_animation_02() -> void : 
	print("Animation02 button was pressed")
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo1",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo2",true)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo3",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo4",false)
	#transition_condition = true

	
	#print("En func la variable est : ",transition_condition)
	#state_machine.travel("Combo_2")
