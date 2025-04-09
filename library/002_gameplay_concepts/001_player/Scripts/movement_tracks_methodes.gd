extends Node
@export var mira_step : AudioStreamPlayer3D
@export var player : CharacterBody3D 
@export var movement_script : PlayerMovementScript
@export var foot_step_vfx : PackedScene
@export var movement_vfx_storage : Node
@export var footstep_sounds : Array[AudioStream]


@onready var rotation_speed : float = 5.0
var direction_vector_input: Vector2
#
#func _ready() -> void:
	#game_master.player_use_charged_attack.connect(launch_charge_attack_mode)
	
func enable_movement() -> void : 
	movement_script.can_move = true
	
func disable_movement() -> void : 
	movement_script.can_move = false

#func instantiate_foot_step_vfx() -> void : 
	#var vfx_instance = foot_step_vfx.instantiate()  # Crée une instance du VFX
	#movement_vfx_storage.add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	#vfx_instance.global_transform = player.global_transform  # Place le VFX exactement où est le joueur
	#play_random_footstep()
	
	
func play_random_footstep() -> void:
	if footstep_sounds.is_empty():
		print("Aucun son de pas assigné !")
		return
	
	var random_index = randi() % footstep_sounds.size()  # Choisir un son aléatoire
	mira_step.stream = footstep_sounds[random_index]
	mira_step.pitch_scale = randf_range(0.9, 1.1)  # Légère variation du pitch pour plus de naturel
	mira_step.play()
