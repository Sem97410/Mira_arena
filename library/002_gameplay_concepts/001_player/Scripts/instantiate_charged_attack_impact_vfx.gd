extends Node

@export var charged_attack_impact_vfx : PackedScene
@export var charged_attack_impact_vfx_storage : Node3D
@export var charged_attack_impact_vfx_spawn_position : Node3D
@onready var vfx_spawned : bool = false


	
func instantiate_charged_attack_impact_vfx() -> void : 
	print("Je suis dans instantiate_charged attack")
	if vfx_spawned:
		return
	
	vfx_spawned = true
	var charged_attack_impact_vfx_instance = charged_attack_impact_vfx.instantiate()

	charged_attack_impact_vfx_storage.add_child(charged_attack_impact_vfx_instance)
	
	# 1. Positionne le VFX à l'emplacement de spawn
	charged_attack_impact_vfx_instance.global_transform = charged_attack_impact_vfx_spawn_position.global_transform
	
	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = charged_attack_impact_vfx_instance.global_transform.origin
	
		# 3. Applique le scale et la rotation en gardant la même position
	var new_basis = charged_attack_impact_vfx_instance.global_transform.basis
	#new_basis = new_basis.rotated(Vector3(0, 0, 1), -PI)  # Rotation de -180° sur l'axe Z
	new_basis = new_basis.scaled(Vector3(2.5, 1, 2.5))
	charged_attack_impact_vfx_instance.global_transform = Transform3D(new_basis, current_position)
	vfx_spawned = false
