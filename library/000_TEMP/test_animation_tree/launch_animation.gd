extends Node

# References
@export var animation_player : AnimationPlayer
@export var animation_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	launch_animation_in_ready()
	
	
func launch_animation_in_ready() -> void : 
	animation_player.play(animation_name)
	print("launch the first animation")
