extends Node

class_name update_target_position

@export var navigation_agent : NavigationAgent3D

func _update_target_position(target_position) :
	navigation_agent.set_target_position(target_position)
	
