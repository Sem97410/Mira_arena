extends CharacterBody3D

class_name Enemy_Slime

@export var navigation_agent : NavigationAgent3D
@export var Player : player

@onready var animation_player: AnimationPlayer = $slime_component/AnimationPlayer

var speed : float = 5
var interpole_speed : float = 15


func _physics_process(delta: float) -> void:
	var slime_current_position = global_transform.origin
	var slime_next_position = navigation_agent.get_next_path_position()
	var new_velocity = (slime_next_position - slime_current_position).normalized() * speed
	velocity = velocity.lerp(new_velocity,interpole_speed * delta)
	
	look_at(- Player.global_position)
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	
	
	
	animation_player.play("slime/Walk")
	move_and_slide()
	
