extends Node

@export var player_collision_shape : CollisionShape3D
@export var player : CharacterBody3D 
var temp_vfx_impact_position : Vector3
@export var attack_vfx_scene : PackedScene
@export var attack_1_sound : AudioStreamPlayer
@export var attack_2_sound : AudioStreamPlayer
@export var attack_3_sound : AudioStreamPlayer

@export var light_attack_vfx_storage : Node

func disable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, true)
	player_collision_shape.disabled = true
	

func enable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, false)
	player_collision_shape.disabled = false
	
func instantiate_attack_vfx() -> void : 
	var vfx_instance = attack_vfx_scene.instantiate()  # Create an instance of the VFX
	light_attack_vfx_storage.add_child(vfx_instance)  # Add vfx in scene
	vfx_instance.global_transform = player.global_transform # Place le VFX exactement où est le joueur


func player_attack_1_sfx() -> void : 
	attack_1_sound.play()
	
func player_attack_2_sfx() -> void : 
	attack_2_sound.play()
	
func player_attack_3_sfx() -> void : 
	attack_3_sound.play()
	
