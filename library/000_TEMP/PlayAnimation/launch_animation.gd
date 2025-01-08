extends Node

@export var play_animation_signal : PlayAnimationSignalResource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation_signal.channel.connect(_launch_animation)


func _launch_animation() -> void :
	print("Play the animation")
