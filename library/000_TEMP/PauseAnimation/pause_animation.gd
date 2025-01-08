extends Node

@export var pause_animation_signal : PauseAnimationSignalResource

func _ready() -> void:
	pause_animation_signal.channel.connect(_pause_animation)


func _pause_animation() -> void: 
	print("The animation was paused")
