extends Node

@export var animation_2_signal : Animation2SignalRessource
@export var animation_player : AnimationPlayer
@export var animation_2_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_2_signal.channel.connect(_play_animation_2)

func _play_animation_2() -> void : 
	print("Animation 2 was played")
	animation_player.play(animation_2_name)
