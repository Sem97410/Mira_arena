extends Area3D

var respawn_position : Vector3
@export var player : CharacterBody3D
@onready var  can_save_position : bool = true

#func _ready() -> void:
	#respawn_position =  player.global_position
	
func _process(delta: float) -> void:
	_save_player_position()
	_allow_save_position()



		
func _save_player_position() -> void:
	if not player.is_on_floor() and can_save_position == true:
		respawn_position = player.global_position
		can_save_position = false
		
func _allow_save_position() -> void :
	if player.is_on_floor():
		can_save_position = true
	
	


func _on_body_entered(body: Node3D) -> void:
	print("je touche l'area")
	if body.is_in_group("player"):
		player.global_position = respawn_position
	
