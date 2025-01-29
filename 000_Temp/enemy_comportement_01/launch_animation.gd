extends Node

class_name  launcherAnimation

@onready var animation: AnimationPlayer = $"../Slime_001/AnimationPlayer"
@onready var slime: Enemy_Slime = $".."


func _physics_process(delta: float) -> void:
	animation.play("Armature|Walk")

 # var animation : get_node("/root/Slime/SlimeComponent/AnimationPlayer")


# func _launch_animation() -> void :
	# animation.play("Slime/Walk")
	
