extends Node

@export var player_collision_shape : CollisionShape3D
@export var player : CharacterBody3D 
var temp_vfx_impact_position : Vector3
@export var attack_vfx_scene : PackedScene
@export var attack_1_sound : AudioStreamPlayer
@export var attack_2_sound : AudioStreamPlayer
@export var attack_3_sound : AudioStreamPlayer

@export var light_attack_vfx_storage : Node

@export var combo_1_position : Node3D

func disable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, true)
	player_collision_shape.disabled = true
	

func enable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, false)
	player_collision_shape.disabled = false
	
func instantiate_attack_vfx() -> void : 
	var vfx_instance = attack_vfx_scene.instantiate()
	light_attack_vfx_storage.add_child(vfx_instance)
	
	# 1. Positionne le VFX à l'emplacement de spawn
	vfx_instance.global_transform = combo_1_position.global_transform
	
	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = vfx_instance.global_transform.origin
	
	# 3. Applique le scale en gardant la même position
	vfx_instance.global_transform = Transform3D(
		Basis(vfx_instance.global_transform.basis.scaled(Vector3(1.5, 1, 1.5))),
		current_position
	)

func player_attack_1_sfx() -> void : 
	attack_1_sound.play()
	
func player_attack_2_sfx() -> void : 
	attack_2_sound.play()
	
func player_attack_3_sfx() -> void : 
	attack_3_sound.play()
	
