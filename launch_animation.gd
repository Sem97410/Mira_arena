extends Node

class_name  launcherAnimation

@onready var animation: AnimationPlayer = $"../AnimationPlayer"



func _physics_process(delta):
	_launch_animation()
	
func _launch_animation(AnimationPlayer):
	animation.play("slime/Walk")
