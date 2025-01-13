extends Node

@export var blend_animation_signal : BlendAnimationSignal
@export var animation_tree : AnimationTree

@onready var animation_1_blend_value = 0.0
@onready var animation_2_blend_value = 1.0




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	blend_animation_signal.channel.connect(_launch_blend_animation)


func _launch_blend_animation() -> void:
	print("Button was pressed")
	animation_tree.set("parameters/StateMachine/attack_combo/blend_position", animation_2_blend_value)
