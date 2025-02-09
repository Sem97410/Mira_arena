extends Node

@export var player : CharacterBody3D 
@export var movement_script : PlayerMovementScript
@export var vfx_scene : PackedScene

func enable_movement() -> void : 
	movement_script.can_move = true
	
func disable_movement() -> void : 
	movement_script.can_move = false

func instantiate_foot_step_vfx() -> void : 
	var vfx_instance = vfx_scene.instantiate()  # Crée une instance du VFX
	get_parent().add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	vfx_instance.global_transform = player.global_transform  # Place le VFX exactement où est le joueur
