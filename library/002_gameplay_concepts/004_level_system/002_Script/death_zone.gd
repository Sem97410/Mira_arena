extends Area3D

var respawn_position: Vector3
@export var player: CharacterBody3D

var time_on_ground: float = 0.0  # Temps accumulé sur le sol
const SAFE_TIME: float = 0.5  # Temps avant de sauvegarder
const SAFETY_OFFSET: float = 1.0  # Distance de recul pour éviter le bord

func _ready() -> void:
	respawn_position = player.global_position  

func _process(delta: float) -> void:
	_save_player_position(delta)

func _save_player_position(delta: float) -> void:
	if player.is_on_floor():
		time_on_ground += delta
		if time_on_ground >= SAFE_TIME:
			# Reculer la position sauvegardée en fonction de la direction inverse du mouvement
			var move_direction = -player.velocity.normalized() * SAFETY_OFFSET
			var safe_position = player.global_position + move_direction
			respawn_position = Vector3(safe_position.x, player.global_position.y, safe_position.z)
	else:
		time_on_ground = 0.0  # Reset si le joueur n'est plus au sol

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Respawn du joueur à :", respawn_position)
		player.global_position = respawn_position
