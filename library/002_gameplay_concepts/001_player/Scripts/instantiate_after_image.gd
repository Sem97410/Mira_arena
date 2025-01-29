extends Node

@export var afterimage_scene: PackedScene  # Utilise MiraAfterImage.tscn

@export var spawn_count: int = 5  
@export var spawn_interval: float = 0.1  
@export var player: CharacterBody3D

var previous_positions: Array = []  # Stocke les anciennes positions du joueur

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		start_spawning()

	# Stocke la position du joueur à chaque frame
	if player:
		previous_positions.append(player.global_transform.origin)

		# Garde seulement les X dernières positions
		if previous_positions.size() > spawn_count:
			previous_positions.pop_front()

func start_spawning() -> void:
	if player == null:
		print("⚠️ Player non assigné !")
		return
	
	spawn_next_mesh(0)



func spawn_next_mesh(index: int) -> void:
	if index >= spawn_count or previous_positions.size() < spawn_count:
		return  

	var new_mesh = afterimage_scene.instantiate() as Node3D  # Instancie l'afterimage
	new_mesh.global_transform.origin = previous_positions[index]  # Place à une ancienne position
	player.get_parent().add_child(new_mesh)
	
	await get_tree().create_timer(spawn_interval).timeout  
	spawn_next_mesh(index + 1)
