extends Node

@export var animation_player : AnimationPlayer
@export var main_menu_pannel : Node3D
@export var pre_menu_pannel : Node3D

func _ready() -> void:
	animation_player.play("StartAnimation")
	await get_tree().create_timer(1.0).timeout
	pre_menu_pannel.visible = true
