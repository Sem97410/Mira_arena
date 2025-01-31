extends Node

class_name SlimeMouvement



@export_multiline var Summary : String # Règle du script a consulter dans l'inspecteur 

@export var slime_data : SlimeData # reférence aux script de la data du slime (ex : speed, life,etc....)
@export var character_body3D : CharacterBody3D # réference au character Body
@export var nav_agent : NavigationAgent3D # réference au Navigation_agent


@onready var speed = slime_data.speed # chargement de la variable  speed stocker sur le script slime_data
@onready var interpolate_strength = slime_data.interpolation_strength # chargement de la variable  interpolate_strength stocker sur le script slime_data
@onready var rotation_axe_x = character_body3D.rotation_degrees.x # chargement de l'axe de rotation du character_body sur x
@onready var rotation_axe_z = character_body3D.rotation_degrees.z # chargement de l'axe de rotation du character_body sur z		
	
	

func _physics_process(delta: float) -> void:
	

	var current_position = character_body3D.global_transform.origin # Position actuelle du charcter_body3D(slime)
	var next_position = nav_agent.get_next_path_position() # Prochiane position du slime/ naviagation agent + La méthode get_next_path_position (propre aux navigationAgent)
	var new_velocity = (next_position - current_position).normalized() * speed # calcule de la vitesse de dépalcement
	character_body3D.velocity = character_body3D.velocity.lerp(new_velocity,interpolate_strength * delta) # affectation de la vitesse aux paramètre velocity + interpolation.


	
	rotation_axe_x = 0 # freeze la rotation en x
	rotation_axe_z = 0 # freeze la rotation en z
	
	character_body3D.move_and_slide()#méthode propre  aux character_body3D, pour le déplacer ( il utilise pour ça le velocity)
	
	

	
	
	
