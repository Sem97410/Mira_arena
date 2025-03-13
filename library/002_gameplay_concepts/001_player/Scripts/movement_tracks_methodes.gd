extends Node
@export var mira_step : AudioStreamPlayer3D
@export var player : CharacterBody3D 
@export var movement_script : PlayerMovementScript
@export var vfx_scene : PackedScene
@export var movement_vfx_storage : Node


@onready var rotation_speed : float = 5.0
var direction_vector_input: Vector2
#
#func _ready() -> void:
	#game_master.player_use_charged_attack.connect(launch_charge_attack_mode)
	
func enable_movement() -> void : 
	movement_script.can_move = true
	
func disable_movement() -> void : 
	movement_script.can_move = false

func instantiate_foot_step_vfx() -> void : 
	var vfx_instance = vfx_scene.instantiate()  # Crée une instance du VFX
	movement_vfx_storage.add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	vfx_instance.global_transform = player.global_transform  # Place le VFX exactement où est le joueur
	mira_step.play()
	
