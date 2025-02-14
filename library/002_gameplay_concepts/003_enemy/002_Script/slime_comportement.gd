extends Node

class_name Slime

#---------------------------------------------------------------------------
## REFERENCES
#Nodes
@onready var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]
@export var animation_player : AnimationPlayer # référence animation player
@export var nav_agent : NavigationAgent3D # référence aux NavigationAgent3D
@export var slime :CharacterBody3D # référence aux character body de l'ennemi

#-----------------------------------
#Movement values

@export var movement_speed : float # vittes de déplacement du slime
@export var movement_interpolate_strength : float # interpolation du mouvement du slime
@onready var rotation_x = slime.rotation_degrees.x # accès a l'axe x du character body
@onready var rotation_z = slime.rotation_degrees.z # accès a l'axe z du character body

#-----------------------------------
#Movement values

var attack_cool_down :float = 0.0 # cool_down pour l'attack du joueur 
var is_attacking = false  #  sert a definir si l'ennemi est en train d'attaquer 

#-----------------------------------
#States values

@onready var current_state = States.CHASING # état de base de notre slime

enum States{ 	# enum qui sert a stocker nos différent états 
	CHASING,	# CHASING : suit le joueur
	PREATTACK,	# PREAATTACK : Se prépare a ttaquer le joueur
	ATTACK,		# ATTACK : Attaque le joueur
	DAMAGE		# DAMAGE : Take damage
	
}


@onready var max_hp : float = 200

@onready var current_hp : float = max_hp


var knockback_force: float = 30.0
var knockback_velocity: Vector3 = Vector3.ZERO  # Stocker la vitesse du knockback


@onready var basic_slime_damage : float = 50.0

@export var slime_attack_area : Area3D

#---------------------------------------------------------------------------


#func _ready() -> void :
	#player_body = SlimeAutoload.player # référence au player    ### Need to check why the autoload references doesn't work
#

	
func _physics_process(delta: float) -> void:
	
			# Add the gravity.
	if not slime.is_on_floor():
		#dummies.velocity += dummies.get_gravity() * delta
		knockback_velocity.y -= 9.8 * delta * 5  # Simule une gravité manuelle
	#print( slime.is_on_floor())
	
	_change_state(current_state,delta) # fonction qui permet le changement d'état
	

		
	# Appliquer le knockback et le réduire progressivement
	if knockback_velocity.length() > 0.1:
		slime.velocity = knockback_velocity
		slime.velocity = knockback_velocity  # Appliquer la vélocité
		slime.move_and_slide()
		knockback_velocity = slime.velocity  # Mettre à jour après collision


		# Réduction progressive du knockback
		knockback_velocity = lerp(knockback_velocity, Vector3.ZERO, 10.0 * delta)
		
	destroy_dummies()
	pass
	
#____________________________________________________________________________________________
#Fonction qui permet le changement détat
#Stock les état dans match new_state et définis quel fonction : état est lancé selon l'état actif
#(delta : float = 0.0 > permet d'attribuer delta a la fonction	san etre obligé de le mettre dans tous les autre fonction 
#interne a change state
func _change_state(new_state : States, delta : float = 0.0) -> void :
	match new_state :
		States.CHASING :
			#print("in chasing states")
			_chasing_state(delta)
		States.PREATTACK :
			#print("in preattack state")
			_pre_attack_state()
		States.ATTACK :
			#print(" in attack state")
			_attack_state()
		States.DAMAGE :
			print("in damage state")
			##_damage_state()
	#____________________________________________________________________________________________		
			
			
#______________Function_Etat_____________________________________________________________________________

#___________________Function_Etat : Chasing State________________________________

#Fonction qui gère le déplacement de l'ennemi  en utilisant  la position de l'ennemi soustrait  à la position du joueur
#Utilise le navigationagent3D et sa méthod next_get_path_position()
#Le navigation agent obtiens la positiont du joueur via la function _update_target_position()
#Utilise la fonction _look_at_player pour regarder dans la direction du joueur
#bloc la rotation en x et z 
#vérifie la distance entre le joueur et l'ennemi pour passer dans l'état PREATTACK 
	
func _chasing_state(delta) -> void:
	var current_position = slime.global_position # position actuelle de l'ennemi
	var next_position = nav_agent.get_next_path_position() # prochaine position de l'ennemi
	var new_velocity = (next_position - current_position).normalized() * movement_speed # calcul la nouvelle vitesse de l'ennemi
	
	#associe la nouvelle vitesse de l'ennemy a la velocity du charracter body utilisation d'un lerp pour fluidifier le mouvement
	slime.velocity = slime.velocity.lerp(new_velocity,movement_interpolate_strength * delta) 
	rotation_x = 0 # freeze la rotation en x
	rotation_z = 0 # freeze la rotation en y 
	
	slime.move_and_slide()
	_look_at_player() # regarder ver le joueur
	animation_player.play("Armature|Walk") # lance l'animation
	
	#___condition pour passer au prochain états_________
	
	#soustrait la position du player a la position de l'ennemi en utilisant la méthode distance_to()
	#pour obtenir la distance entre l'ennemi et le joueur
	#si la distance entre l'ennemi et le joueur et inférieur ou égal a 3 passe en état PREATTAC
	#sinon reste dans l'état CHASING
	
	var player_position = player.global_position # position du joueur
	var enemy_position = slime.global_position # position de l'ennemi
	var distance_to_player = player_position.distance_to(enemy_position)# distance entre le joueur et l'ennemi
	if distance_to_player <= 3 : # si la distance ennemi_player est inf ou égal a 3
		current_state = States.PREATTACK # état actuel = a l'état PREATTACK
	else :# sinon
		current_state = States.CHASING # état actuel = a l'état CHASING
#____________________________________________________________________________________________		
		
		
#___________________Function_Etat : Pre_attack________________________________
#lance l'animation preattack
#attend 0.4 milliseconde
#passe a l'état ATTACK
	
func _pre_attack_state() -> void :
	animation_player.play("Armature|pre_charge") #lance l'animation
	await get_tree().create_timer(0.4).timeout # crée un timer de 0.4 milliseconde
	current_state  = States.ATTACK # état actuel = a létat ATTACK
#____________________________________________________________________________________________



#___________________Function_Etat : Attack________________________________
#vérifie si l'ennemi est en attaque 
#au début non : if not is_attacking
#dans ce cas joue l'animation de charge
#le coolDown d'attaque est égal a 0.5 milliseconde
#l'ennemi est en attaque : is_attacking = true
#ensuite un cooldown va être lancé  qui va empéché l'ennemi d'attaqué pendant 0.5 milliseconde
#si ce cooldown est sup a zero ce cooldown va etre soustrait par la méthode get_process_delta_time()
#sinon si ce cooldown n'est pas superieur a zéro
#il verifie sa distance avce le joueur 
#selon la distance il repart en PREATTACK ou en CHASING
func _attack_state() -> void:
	if not is_attacking:# si il n'est pas en train d'ataquer
		#print("in attack state")
		animation_player.play("Armature|charge")#joue l'animation d'attaque
		attack_cool_down =0.5# le cool down est égal a 0.5 milliseconde
		is_attacking = true	# il est en train d'attaquer
		
#si mon cool_down est sup a zero
#alors il est égal a get_process_delta_time() ->(petit chronomètre qui va et soustraire du temps a mon cooldown)			
	if attack_cool_down > 0: #si le cooldown est supérieur a zero
		attack_cool_down -= get_process_delta_time()# le cooldown est soustrait a get_procces_delta_time() jusqu'a le ramené à zero 
				
#sinon si mon cooldown n'est pas superieur a zero l'ennemi revérifie sa distance avec le joueur 
#si elle supérieur a 3 il n'attaque plus 
#il repasse dans l'état CHASING
#sinon il se remet en PREATTACK
	else:
		is_attacking = false
		var player_position = player.global_position # position du jouer
		var enemy_position = slime.global_position # positon de l'enemi
		var distance_to_player = player_position.distance_to(enemy_position) # distance enemmi_player
		
		if distance_to_player > 3 : #si la distance est supérieur a 3
			current_state = States.CHASING # l'état actuel est égal a CHASING
		else :
			current_state = States.PREATTACK # l'état actuel est égal a PREATTACK
#____________________________________________________________________________________________


#___________________Function_non_état________________________________

#______________________________________________________________
#function qui permet a l'ennemi de regarder dans la direction  du joueur avec la méthode look_at()
func _look_at_player() -> void :
	slime.look_at(player.global_position)# la fonction look_at(récupère la position du joueur)
#____________________________________________________________________________________________	
	
	
#______________________________________________________________
#function qui permet d mettre a jour la position du joueur  pour le navigation agent	
func _update_target_position(target_position): # paramètre target position -> Vector3 qui est initialisé lors de l'appel de la fonction
	nav_agent.set_target_position(target_position)# récupère le Vector3 initialisé lors de l'appel de la fonction et l'associe aux navigation_agent
#____________________________________________________________________________________________
	
	
func take_damage(damage : float) -> void : 
	#print("Ouille")
	
	current_state = States.DAMAGE
	
	
	current_hp -= damage
	#print("Dummies hp : ", current_hp)
	
	knockback()
	
	await get_tree().create_timer(0.7).timeout  # Duration of the damage state
	
	var player_position = player.global_position # position du jouer
	var enemy_position = slime.global_position # positon de l'enemi
	var distance_to_player = player_position.distance_to(enemy_position) # distance enemmi_player
		
	if distance_to_player > 3 : #si la distance est supérieur a 3
		current_state = States.CHASING # l'état actuel est égal a CHASING
	else :
		current_state = States.PREATTACK # l'état actuel est égal a PREATTACK
	



func destroy_dummies() -> void : 
	if current_hp <= 0 : 
		slime.queue_free()
		
		
func knockback() -> void:
	var direction = (slime.global_position - player.global_position).normalized()
	direction.y = 0  # Neutraliser le déplacement vertical pour la rotation

	# Ajouter le knockback progressif
	knockback_velocity = direction * knockback_force

	# Ajouter une impulsion verticale pour créer l'arc
	knockback_velocity.y = knockback_force * 0.5  # Ajuste ce facteur pour plus ou moins d'arc

	# Regarder dans la direction opposée au joueur
	slime.look_at(slime.global_position - direction)

		
		
		
func make_damage(area : Area3D, damage : float) -> void : 
	# Récupérer le nœud parent de l'Area
	var parent = area.get_parent()
	
	# Trouver le nœud avec la fonction take_damage parmi les frères
	for sibling in parent.get_children():
		
		if sibling.is_in_group("player") and sibling.has_method("take_damage"):
			sibling.take_damage(damage)
			#print("Il a la fonction take_damage")
			break
			
		else : 
			print("Il n'a pas la fonction")


func _on_area_3d_area_entered(area: Area3D) -> void:
	make_damage(area, basic_slime_damage)


func disable_attack_area() -> void : 
	slime_attack_area.monitorable = true
	
func enable_attack_area() -> void : 
	slime_attack_area.monitorable = false
