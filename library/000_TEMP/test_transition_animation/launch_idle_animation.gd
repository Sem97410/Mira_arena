extends Node
@export var idle_animation_signal : IdleAnimationSignalResource

@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/StateMachine/StateMachine2/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle_animation_signal.channel.connect(_launch_idle_animation)

func _launch_idle_animation() -> void : 
	print("idle button was pressed")
	state_machine.travel("Iddle")
