extends Node

@export var state_machine_1_signal : StateMachine1SignalResource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine_1_signal.channel.connect(_launch_state_machine_1_animations)


func _launch_state_machine_1_animations() -> void : 
	print("Launch of the StateMachine 1 animations")
