extends Node

@export var player_collision_shape : CollisionShape3D
@export var player : CharacterBody3D 
var temp_vfx_impact_position : Vector3

@export var attack_1_sound : AudioStreamPlayer
@export var attack_2_sound : AudioStreamPlayer
@export var attack_3_sound : AudioStreamPlayer

@export var light_attack_vfx_storage : Node

var current_vfx : MeshInstance3D
@export var combo_1_vfx_scene : PackedScene


@export var combo_2_vfx_scene: PackedScene
@export var base_combo_position : Node3D

@export var attack_2_rotation : int

@export var combo_3_animation_player : AnimationPlayer
@export var combo_3_vfx : Node3D

func disable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, true)
	player_collision_shape.disabled = true
	

func enable_collision_shape() -> void : 
	player.set_axis_lock(PhysicsServer3D.BODY_AXIS_LINEAR_Y, false)
	player_collision_shape.disabled = false
	
func destroy_light_attack_vfx() -> void : 
	current_vfx.queue_free()


func instantiate_combo_1_vfx() -> void : 
	var combo_1_vfx_instance = combo_1_vfx_scene.instantiate()
	current_vfx = combo_1_vfx_instance
	light_attack_vfx_storage.add_child(combo_1_vfx_instance)
	
	# 1. Positionne le VFX à l'emplacement de spawn
	combo_1_vfx_instance.global_transform = base_combo_position.global_transform
	
	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = combo_1_vfx_instance.global_transform.origin
	
	# 3. Applique le scale en gardant la même position
	combo_1_vfx_instance.global_transform = Transform3D(
		Basis(combo_1_vfx_instance.global_transform.basis.scaled(Vector3(1.5, 1, 1.5))),
		current_position
	)
	

	
func instantiate_combo_2_vfx() -> void : 
	var combo_2_vfx_instance = combo_2_vfx_scene.instantiate()
	current_vfx = combo_2_vfx_instance
	light_attack_vfx_storage.add_child(combo_2_vfx_instance)
	
	# 1. Positionne le VFX à l'emplacement de spawn
	combo_2_vfx_instance.global_transform = base_combo_position.global_transform
	
	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = combo_2_vfx_instance.global_transform.origin
	
	# 3. Applique le scale et la rotation en gardant la même position
	var new_basis = combo_2_vfx_instance.global_transform.basis
	new_basis = new_basis.rotated(Vector3(0, 0, 1), -PI)  # Rotation de -180° sur l'axe Z
	new_basis = new_basis.scaled(Vector3(1.5, 1, 1.5))
	combo_2_vfx_instance.global_transform = Transform3D(new_basis, current_position)
	

func enable_combo_3_vfx() -> void : 
	combo_3_vfx.visible = true

func disable_combo_3_vfx() -> void : 
	combo_3_vfx.visible = false
	
func launch_combo_3_vfx_animation() -> void : 
	combo_3_animation_player.play("Attack_Charge")
	print("Launch animation 3 ")
	
func player_attack_1_sfx() -> void : 
	attack_1_sound.play()
	
func player_attack_2_sfx() -> void : 
	attack_2_sound.play()
	
func player_attack_3_sfx() -> void : 
	attack_3_sound.play()
	
