extends Node
@export var animation_signal_resource_01 : AnimationSignalResource01

@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/StateMachine/StateMachine1/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_signal_resource_01.channel.connect(_launch_animation_01)

func _launch_animation_01() -> void : 
	print("Animation01 button was pressed")
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo1",true)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo2",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo3",false)
	animation_tree.set("parameters/StateMachine/StateMachine1/conditions/isCombo4",false)

	state_machine.travel("Combo_1")
