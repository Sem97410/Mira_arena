extends Node

@export var animation_player : AnimationPlayer
@export var vfx : Node3D


func destroy_vfx() -> void : 
	vfx.queue_free()
