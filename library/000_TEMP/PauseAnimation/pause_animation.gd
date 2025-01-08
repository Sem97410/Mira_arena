extends Node

@export var animation_signal : PlayAnimationSignalResource

func _ready() -> void:
	animation_signal.channel.connect(_pause_animation)


func _pause_animation() -> void: 
	print("The animation was paused")
