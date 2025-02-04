extends Node

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@onready var base_state_machine  = animation_tree["parameters/MiraAnimations/playback"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
