extends Node
@export var projectil : MeshInstance3D

func instantiate_vfx( vfx: PackedScene) -> void:
	if vfx == null:
		#print("❌ Erreur : Le VFX est nul, impossible d'instancier.")
		return

	var vfx_instance = vfx.instantiate()
	if not vfx_instance:
		#print("❌ Erreur : Impossible d'instancier le VFX.")
		return

	# Ajouter le VFX à la scène AVANT de modifier sa position
	get_tree().current_scene.add_child(vfx_instance)
	#print("Instantiation reussi")

	# Maintenant, on peut modifier sa position
	vfx_instance.global_position = projectil.global_position
