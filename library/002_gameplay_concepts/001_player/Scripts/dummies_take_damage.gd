extends Node

@onready var max_hp : float = 100

@onready var current_hp : float = max_hp

@export var dummies : CharacterBody3D


func _ready() -> void:
	print("Dummies hp : ", current_hp)
	
func _process(delta: float) -> void:
	destroy_dummies()

func take_damage(damage : float) -> void : 
	print("Ouille")
	print("Damage is : ", damage)
	current_hp -= damage
	print("Dummies hp : ", current_hp)


func destroy_dummies() -> void : 
	if current_hp <= 0 : 
		dummies.queue_free()
