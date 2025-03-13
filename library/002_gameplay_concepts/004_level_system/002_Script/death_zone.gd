extends Area3D

var respawn_position : Vector3
@export var player : CharacterBody3D

func _ready() -> void:
	respawn_position =  player.global_position
	


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		player.global_position = respawn_position
