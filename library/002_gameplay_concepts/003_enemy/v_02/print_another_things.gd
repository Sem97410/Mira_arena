extends Node

@export var message2 : String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Debug_2"):
		print(message2)
