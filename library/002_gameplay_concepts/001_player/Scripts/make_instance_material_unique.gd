extends Node

@export var after_image_mesh: MeshInstance3D

func _ready() -> void:
	duplicate_material()

func duplicate_material() -> void:
	if after_image_mesh:
		var material = after_image_mesh.get_surface_override_material(0)
		if material:
			var unique_material = material.duplicate()  # Duplique le matériau
			after_image_mesh.set_surface_override_material(0, unique_material)  # Applique la copie
