extends Node

@export var animation_04_signal : Animation4SignalRessource
@export var animation_player : AnimationPlayer
@export var animation_04_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_04_signal.channel.connect(_play_animation_04)



func _play_animation_04() -> void : 
	print("The button for the animation 4 was pressed")
	animation_player.play(animation_04_name)
