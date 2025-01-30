extends Node

class_name  Launch_Animation

@export_multiline var Summary : String
@export var animation_player :AnimationPlayer


func _physics_process(delta):
	_lauch_animation()

func _lauch_animation() -> void :
	animation_player.play("Slime/Walk")


	
