extends Node

#References
@export var animation1_signal : Animation1SignalRessource
@export var animation_player : AnimationPlayer
@export var animation_1_name : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connexion with the signal
	animation1_signal.channel.connect(_play_animation_1)

#Launch the animation
func _play_animation_1() -> void : 
	print("The button for the animation 1 was pressed")
	animation_player.play(animation_1_name)
	
