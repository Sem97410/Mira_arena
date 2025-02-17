extends Node
@export var current_vfx : Node3D
@export var delay_before_queue_free : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroy_attack_vfx(current_vfx, delay_before_queue_free)

func destroy_attack_vfx(current_vfx : Node3D, delay : float) -> void : 
	await get_tree().create_timer(delay_before_queue_free).timeout
	current_vfx.queue_free()
