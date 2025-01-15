extends Node
@export var animation_signal_resource_03 : AnimationSignalResource03

@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/StateMachine/StateMachine1/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_signal_resource_03.channel.connect(_launch_animation_03)

func _launch_animation_03() -> void : 
	print("Animation03 button was pressed")
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo1",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo2",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo3",true)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo4",false)

	state_machine.travel("Combo_3")
