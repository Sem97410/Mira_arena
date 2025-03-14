extends Node

@export var sound_slime : AudioStreamPlayer3D


func _launch_slime_step() -> void :
	sound_slime.play()
