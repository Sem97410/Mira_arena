extends Node
class_name DropHealthLogic


@export var health_item_scene : PackedScene
@export var drop_chance : float = 0.15
@export var slime : CharacterBody3D 

	
func drop_health_item(position : Vector3) -> void : 
	if not health_item_scene or not slime:
		return

	#
	#if not slime.is_inside_tree() :
		#print("Pas dans l'arbre")
		#return
		
	if randf() <= drop_chance :
		print("Suppose to print un truc")
		var health_item_instance = health_item_scene.instantiate()
		
		get_tree().current_scene.add_child(health_item_instance)
		health_item_instance.global_transform.origin = position
