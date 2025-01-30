extends Node


@export var fade_out_time: float = 0.5  # Temps avant disparition
@export var after_image_mesh : MeshInstance3D
@export var root : Node3D

func _ready() -> void:
	
	start_fade_out()

func start_fade_out() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(after_image_mesh.material_override, "Albedo:a", 0.0, fade_out_time)  # Réduit l'opacité
	await get_tree().create_timer(0.5).timeout
	root.queue_free()  # Supprime l’afterimage après le fade
