extends Node
@onready var vfx_instance : GPUParticles3D = get_parent()
@export var delay_before_destruction : float



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destroy_vfx_after_delay() # Replace with function body.


func destroy_vfx_after_delay() -> void : 
	await get_tree().create_timer(delay_before_destruction).timeout
	vfx_instance.queue_free()
	
