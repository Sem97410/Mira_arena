extends Node

@export var transition_signal : ManageAnimationSignal
@export var animation_tree : AnimationTree
@onready var can_transition : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition_signal.chanel.connect(_handle_transition)


func _handle_transition() -> void : 
	print("Handling the transition")
	animation_tree.set("parameters/FightStateMachine/conditions/can_transition", not can_transition)
