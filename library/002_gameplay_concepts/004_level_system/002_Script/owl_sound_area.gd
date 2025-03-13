extends Area3D
@export var owls_sound : AudioStreamPlayer3D



func _on_body_entered(body: Node3D) -> void:
	if body.name == "Mira" :
		owls_sound.play()
			


func _on_body_exited(body: Node3D) -> void:
	if body.name == "PlayerPawn" :
		owls_sound.stop()
