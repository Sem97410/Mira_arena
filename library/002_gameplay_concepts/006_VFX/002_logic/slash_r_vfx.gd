extends MeshInstance3D

@export var animation_player : AnimationPlayer
@export var base_node : Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("light_attack"):
		player_vfx()

func player_vfx() -> void : 
	base_node.visible = true
	animation_player.play("RESET")
	print("Vfx was played")
	
	await get_tree().create_timer(0.3).timeout
	base_node.visible = false
	
