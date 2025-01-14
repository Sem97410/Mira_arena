extends Node

@export var state_machine_2_signal : StateMachine2SignalResource
@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/StateMachine/playback"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine_2_signal.channel.connect(_launch_state_machine_1_animations)


func _launch_state_machine_1_animations() -> void : 
	print("Launch of the StateMachine 2 animations")
	state_machine.travel("StateMachine2")
