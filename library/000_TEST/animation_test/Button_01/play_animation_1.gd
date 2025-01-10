extends Node

@export var animation1_signal : Animation1SignalRessource
@export var animation_player : AnimationPlayer
@export var animation_1_name : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation1_signal.channel.connect(_play_animation_1)


func _play_animation_1() -> void : 
	print("First animation was launch")
	animation_player.play(animation_1_name)
	
