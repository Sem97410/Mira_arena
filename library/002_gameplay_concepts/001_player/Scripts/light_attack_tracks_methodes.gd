extends Node

@export var player_collision_shape : CollisionShape3D
@export var player : CharacterBody3D 
var temp_vfx_impact_position : Vector3
@export var attack_vfx_scene : PackedScene
@export var attack_sound : AudioStreamPlayer

func disable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, true)
	player_collision_shape.disabled = true
	

func enable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, false)
	player_collision_shape.disabled = false
	
func instantiate_attack_vfx() -> void : 
	var vfx_instance = attack_vfx_scene.instantiate()  # Crée une instance du VFX
	get_parent().add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	vfx_instance.global_transform = player.global_transform # Place le VFX exactement où est le joueur
	print("launch_vfx")

func player_attack_sfx() -> void : 
	attack_sound.play()
	print("Play sound")
	
