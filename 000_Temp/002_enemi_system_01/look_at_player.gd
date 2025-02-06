extends Node

class_name LookAtPlayer

@export var character_body3D : CharacterBody3D
@onready var player = PlayerData.player

func _physics_process(delta):
		character_body3D.look_at(player.global_position) # permet a l'énemi d'orenté son regard vers le joueur 
