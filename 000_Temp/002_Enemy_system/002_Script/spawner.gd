extends Node3D

@onready var spawner_timer: Timer = $SpawnerTimer
@onready var 

const SLIME = preload("res://000_Temp/002_Enemy_system/001_SCENE/slime.tscn")

func _on_spawner_timer_timeout() -> void:
	print("spawn !")
	var newEnemy = SLIME.instantiate()
	get_parent().add_child(newEnemy)
	newEnemy.global_position = global_position
