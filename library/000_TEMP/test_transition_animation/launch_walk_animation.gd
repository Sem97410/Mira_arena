extends Node
# -----------------------------
## REFERENCES
# Signal
@export var walk_animation_signal : WalkAnimationSignalResource
# ------------
#ANIMATIONTREE INFORMATIONS
@export var animation_tree : AnimationTree
#get the Playback of the StateMachine2
@onready var state_machine = animation_tree["parameters/StateMachine/StateMachine2/playback"]


func _ready() -> void:
	#Connexion with the signal
	walk_animation_signal.channel.connect(_launch_walk_animation)

func _launch_walk_animation() -> void : 
	print("walk button was pressed")
	#Create a transition to the "Walk" node into the StateMachine2
	state_machine.travel("Walk")
