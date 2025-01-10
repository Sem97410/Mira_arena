extends Node

@export var animation_3_signal : Animation3SignalRessource
@export var animation_player : AnimationPlayer 
@export var animation_3_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_3_signal.channel.connect(_play_animation_3)


func _play_animation_3() -> void : 
	print("The button for the animation 3 was pressed")
	animation_player.play(animation_3_name)
	
