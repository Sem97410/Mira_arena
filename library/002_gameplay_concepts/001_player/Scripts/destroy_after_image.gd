extends Node


@export var fade_out_time: float = 0.5  # Temps avant disparition
@export var after_image_mesh : MeshInstance3D
@export var root : Node3D

func _ready() -> void:
	
	destroy_after_image_with_delay()


func destroy_after_image_with_delay() -> void:
	
	await get_tree().create_timer(1).timeout
	root.queue_free()  #
