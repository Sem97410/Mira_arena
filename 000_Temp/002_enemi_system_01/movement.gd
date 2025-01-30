extends Node


class_name ennemi_movement

@export_multiline var Summary : String # Règle du script a consulter dans l'inspecteur 
@export var slime_data : SlimeData # référence a la data du slime
@export var character_body3D : CharacterBody3D # réference au character Body

@export var nav_agent : NavigationAgent3D # réference au Navigation_agent



var player = null
 
func _ready() -> void:
	player = PlayerData.player
	if player :
		print("player is here")
	else :
		print("player is not found")
	

	
	


func _physics_process(delta: float) -> void:
	var speed = slime_data.speed # référence a la data speed du slime
	var interpolate_strength = slime_data.interpolation_strength # référence a la data interpolate_strength du slime
	var rotation_axe_x = character_body3D.rotation_degrees.x # axe de rotation du character_body sur x
	var rotation_axe_z = character_body3D.rotation_degrees.z # axe de rotation du character_body sur z		
	var current_position = character_body3D.global_transform.origin # Position actuelle du charcter_body3D(slime)
	var next_position = nav_agent.get_next_path_position() # Prochiane position du slime/ naviagation agent + La méthode get_next_path_position (propre aux navigationAgent)
	var new_velocity = (next_position - current_position).normalized() * speed # calcule de la vitesse de dépalcement

	#character_body3D.velocity = character_body3D.velocity.lerp(new_velocity,interpolate_strength * delta)  # affectation de la vitesse aux paramètre velocity + interpolation.
	#if player :
		#character_body3D.look_at(player.global_position) # permet a l'énemi d'orenté son regard vers le joueur 
	#else : 
		#print("erreur")
		#print(player)
	
	rotation_axe_x = 0 # freeze la rotation en x
	rotation_axe_z = 0 # freeze la rotation en z
	character_body3D.move_and_slide()
	
	
