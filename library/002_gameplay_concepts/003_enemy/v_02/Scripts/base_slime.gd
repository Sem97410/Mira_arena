extends BaseEnemy
class_name BaseSlime


#----------------------------------------------
##SUMMARY
#This script is suppose to be the base of every 
#kind of slime enemy. 
#It is composed of different functions that will
#be use in the creation of different behavior for
#the slim

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##VARIABLES

#----------------------
@export_category("General variables")

#general variables
var player_position : Vector3
var target_position : Vector3






#----------------------
#Health variables


#----------------------
@export_category("Meshes variables")

#Mesh variables
@export var damage_stars : Node3D
@export var slime_body : Node3D
#----------------------
#Fight variables
@export_category("Fight variables")
@onready var attack_range : float = 3.0
@onready var pre_explosion_attack_range = 6.0
@onready var launch_explosion_range = 1.0
var distance_to_target : float
@export var pre_attack_duration : float = 2.0
@export var dash_duration: float = 0.2 #In second
@export var latence_between_dash : float = 3.0
@export var dash_length : float
@onready var start_time : int = 0 #When the dash start
@onready var dash_countdown : float = 0.0
var start_position : Vector3 #Begining of the dash
var destination_target : Vector3 #End of the dash
var was_in_air = false  # Pour savoir si on était en l'air avant le dash
@export var attack_cool_down :float = 0.0 # cool_down pour l'attack du joueur
@export var explosion_area : Area3D
@export var explosion_vfx : PackedScene

@export var attack_area : Area3D
@export var slime_attack_damage : float

@export var pre_attack_indicator : Sprite3D
@export var attack_indicator : Sprite3D

@export var pre_explosion_duration : float
@export var explosion_damage : float
#----------------------
#Movement variables
@onready var can_jump : bool = true

@onready var jump_height = 1.5  # Hauteur du saut
@onready var duration = 0.5  # Temps total du saut
@onready var elapsed_time = 0
@onready var random_point_interval : float = 0.5
var random_point_around_target : Vector3
@onready var is_generating_random_point = false  # Pour éviter les doublons
var random_point_navmesh: Vector3
@export var time_before_new_target: float = 5.0

#----------------------
@export_category("Animation variables")

#Animation variables
@export var death_animation_duration : float

#----------------------
#Vfx variables
@export var death_vfx : PackedScene
#----------------------

#----------------------
@export_category("Items variables") ## MUST BE DELETE
#Items variables
@export var health_item_scene : PackedScene
@export var drop_chance : float = 0.15
#----------------------
#Debug variables
@export_category("Debug variables") ## MUST BE DELETE
#add a comment NEED TO BE SUPP
@export var target_entity : Node3D   #Test that allow me to assign a target with the inspector. In the final code the slime will assign the target through the code

#----------------------

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##FUNCTIONS

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") #Assign the player
	can_move = true
	current_health_point = max_health_point


func _process(delta: float) -> void:
	apply_gravity(delta)  # Applique la gravité toujours
	player_position = player.global_transform.origin
	distance_to_target = check_distance_to_target(player)
	create_attack_cooldown()
	
	# Applique le knockback s'il est actif
	apply_knockback_movement(delta)

	#print("Slime Position:", slime.global_position)
	#print("Is on floor:", slime.is_on_floor())
	#print("Start time is : ", start_time)


#----------------------------------------------
#region Check States Region
func check_distance_to_target(target : Node3D) -> float :
	return global_position.distance_to(target.global_position)
#---
func send_event_state_chart(event_name : String)-> void :
	state_chart.send_event(event_name)
#---
func activate_hunt_mode() -> void :
	distance_to_target = check_distance_to_target(player)
	#print("Distance to target is : ", distance_to_target)
	if distance_to_target > attack_range :
		#print("Move in hunting mode")
		send_event_state_chart("IsHunting")

#---
func activate_wander_mode() -> void :
	distance_to_target = check_distance_to_target(player)
	#print("Distance to target is : ", distance_to_target)
	if distance_to_target > attack_range :
		#print("Move in hunting mode")
		send_event_state_chart("IsWander")
#---
func activate_idle_mode() -> void :
	var distance_to_target = check_distance_to_target(player)
	if distance_to_target <= attack_range :
		#print("Move in Idle mode")
		send_event_state_chart("IsIdle")
#---
func activate_pre_attack_mode() -> void :
	
	distance_to_target = check_distance_to_target(player)
	if distance_to_target <= attack_range :
		#print("Move in preattack mode")
		send_event_state_chart("IsPreAttack")
#---
func activate_pre_explosion_mode() -> void :
	distance_to_target = check_distance_to_target(player)
	#print("distance to target is : ", distance_to_target)
	
	if distance_to_target <= pre_explosion_attack_range: 
		send_event_state_chart("IsPreExplosing")
		#print("Send event for pre explosing")
	
func _on_hunt_state_processing(delta: float) -> void:
	get_random_point_around(3.0)  # Change la cible régulièrement
	can_move = true
	move(random_point_around_target, delta)
	entity_rotation()
	look_at_target_or_movement(slime, player, slime.velocity, 10.0)
	
	print("Je suis dans hunt")

	distance_to_target = check_distance_to_target(player)
	
	if distance_to_target <= attack_range and attack_cool_down <= 0 :
		#print("I'm able to go to pre attack")
		#print("Move in Idle mode")
		activate_pre_attack_mode()
		activate_pre_explosion_mode()
	elif attack_cool_down > 0 :
		activate_idle_mode()

	animation_player.play("Slime|Walk")
#---
func _on_idle_state_processing(delta: float) -> void:
	can_move = false
	#print("I'm in idle")

	animation_player.play("Slime|idle")
	
	if distance_to_target <= attack_range and attack_cool_down <= 0 :
		activate_pre_attack_mode()
		activate_pre_explosion_mode()
		
	activate_hunt_mode()
	activate_wander_mode()
	
	
#---
func _on_pre_attack_state_entered() -> void:
	pre_attack_indicator.visible = true
#---
func _on_pre_attack_state_exited() -> void:
	pre_attack_indicator.visible = false
#---
func _on_pre_attack_state_processing(delta: float) -> void:
	#print("I'm in pre attack")
	
	can_move = false
	animation_player.play("Slime|pre_charge")
	await get_tree().create_timer(2.0).timeout
	state_chart.send_event("IsAttacking")

#---
func _on_attack_state_entered() -> void:
	#print("I'm in attack state")
	start_dash()
	attack_indicator.visible = true
#---
func _on_attack_state_exited() -> void:
	attack_indicator.visible = false
#---
func _on_attack_state_processing(delta: float) -> void:
	execute_dash()
#---


#endregion
#----------------------------------------------
#region Health Region
##Health functions

func _on_hit_reaction_state_entered() -> void:
	#print("I'm in hit reaction!")
	damage_stars.visible = true
	check_if_dead()
	knockback(player_position)
	#can_move = false


func _on_hit_reaction_state_exited() -> void:
	damage_stars.visible = false
	#can_move = true


	
func check_if_dead()-> void:
	
	if current_health_point <= 0 :
		state_chart.send_event("IsDead")
		state_chart.send_event("IsSelfDestructing")

	
func _on_death_state_entered() -> void:
	slime_body.visible = false
	drop_health_item(slime.global_position)
	instantiate_vfx(slime.global_position, death_vfx )
	death(slime, 1.5)
#----------------------------------------------
#endregion
#----------------------------------------------
##Mesh functions

#----------------------------------------------
#region Fight Region
#----------------------------------------------
##Fight functions
func _on_attack_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("player"):
		print("Contact with player")
		make_damage(area, slime_attack_damage)


#----------------------------------------------
##Movement functions

#endregion

#region Movement Region
func calculate_destination(target: Node3D) -> Vector3:
	if target:
		return target.global_position
	return slime.global_position  # Si la cible est invalide, le slime reste sur place
#---
func create_random_point_around(target: Vector3, range: float) -> Vector3:
	var offset_x = randf_range(-range, range)
	var offset_z = randf_range(-range, range)
	var new_point = Vector3(target.x + offset_x, target.y, target.z + offset_z)
	
	
	return new_point
	
func create_attack_cooldown() -> void :
	if attack_cool_down > 0: #si le cooldown est supérieur a zero
		attack_cool_down -= get_process_delta_time()# le cooldown est soustrait a get_procces_delta_time() jusqu'a le ramené à zero

#---
func get_random_point_around(range: float) -> void:
	if is_generating_random_point:
		return  # Empêche de relancer la fonction si elle est déjà en cours
	
	is_generating_random_point = true  # Marque comme en cours
	await get_tree().create_timer(random_point_interval).timeout
	random_point_around_target = create_random_point_around(player_position, range)
	is_generating_random_point = false  # Marque comme terminé
#---
#---
func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	if not can_jump:
		#print("Je peux pas sauter")
		#print("can jump devrait etre faux ici et il est  : ", can_jump)
		return  # Bloque si un saut est déjà en cours
	#
	can_jump = false  # Désactive le saut temporairement
	#print("Je suis dans la fonction avant le calcule et can jump devrait etre faux il est : ", can_jump)
	var start_position = details["link_entry_position"]  # Point A
	var end_position = details["link_exit_position"]    # Point B
	jump_to_target(start_position, end_position)
	#print("can jump : ", can_jump)
#---
#A DOCUMENTER
func jump_to_target(start: Vector3, end: Vector3) -> void:
	elapsed_time = 0.0

	while elapsed_time < duration:
		# Vérifier si l'objet est toujours valide ET qu'il est dans l'arbre de scène
		if not is_instance_valid(self) or not is_inside_tree():
			return  # Stoppe immédiatement si le nœud n'existe plus ou est supprimé

		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
		
		var t = elapsed_time / duration  # Normalisation du temps (0 à 1)
		
		# Vérifier encore avant d'accéder à global_transform
		if not is_instance_valid(self) or not is_inside_tree():
			return

		# Lerp entre A et B
		var new_position = start.lerp(end, t)
		
		# Ajouter la hauteur du saut avec une parabole
		new_position.y += jump_height * sin(t * PI)
		
		# Vérifier encore une fois avant de modifier la position
		if not is_instance_valid(slime) or not slime.is_inside_tree():
			return

		slime.global_transform.origin = new_position

	# Vérifier avant d'attendre (évite une erreur si la scène a changé entre-temps)
	if not is_instance_valid(self) or not is_inside_tree():
		return

	await get_tree().create_timer(0.2).timeout  # Petit délai pour éviter un double trigger

	# Vérifier avant de réactiver le saut
	if is_instance_valid(self) and is_inside_tree():
		can_jump = true


#---
func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3):
	stored_safe_velocity = safe_velocity

##DASH V2
func start_dash():

	# Initialisation des variables pour le dash
	activate_attack_area(attack_area)
	attack_cool_down = 2.0
	start_position = slime.position  # Stocke la position de départ du slime
	start_time = Time.get_ticks_msec()  # Sauvegarde le moment exact où le dash commence
	
	# Définir la direction du dash (en tenant compte de la direction de l'axe z de la transformation)
	var direction = -slime.transform.basis.z
	#direction.y = 0  # Bloque l'inclinaison verticale
	direction = direction.normalized()  # Normaliser la direction pour éviter des bugs
	
	# Définir la destination du dash en fonction de la direction et de la longueur du dash
	destination_target = slime.position + direction * dash_length

	# Vérifie si le slime était en l'air avant de dasher
	was_in_air = not slime.is_on_floor()
#---
#Dash physical movement
func execute_dash():
	if start_time > 0:  # Active le dash seulement si start_time est défini
		var elapsed_time = (Time.get_ticks_msec() - start_time) / 1000.0  # Temps écoulé depuis le début du dash
		var t = elapsed_time / dash_duration  # Normalisation du temps (de 0 à 1)

		# Si le dash est terminé ou que le cooldown d'attaque est atteint
		if t >= 1 or attack_cool_down <= 0:
			stop_dash()
			return

		# Calcul de la direction du dash
		var dash_direction = (destination_target - start_position).normalized()
		var dash_speed = (destination_target - start_position).length() / dash_duration
		var velocity = dash_direction * dash_speed

		# Désactiver temporairement la détection du sol en passant en mode flottant
		slime.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		look_at_target_or_movement(slime, player, slime.velocity, 10.0)

		# ⚠️ NE PAS AJUSTER LA HAUTEUR SI LE SLIME DANS LES AIRS ⚠️
		if not was_in_air:
			if dash_direction.y >= 0:
				var ground_height = adjust_height_to_ground(slime.global_transform.origin + velocity * get_physics_process_delta_time())
				var target_y = ground_height.y
				velocity.y = lerp(slime.velocity.y, target_y - slime.global_transform.origin.y, 0.1)  # Lissage progressif
			# Si le slime dash vers le bas, on laisse la physique gérer

		# Déplacement avec move_and_slide
		slime.velocity = velocity
		slime.move_and_slide()

		# Réactiver la détection du sol après le dashq
		slime.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED

		# Lancer l'animation pendant le dash
		animation_player.play("Slime|Charge")
#---
func adjust_height_to_ground(target_position: Vector3) -> Vector3:
	#print('I am in ajust_height_to_ground')
	var space_state = slime.get_world_3d().direct_space_state

	# Raycast vers le bas (pour coller au sol si nécessaire)
	var ray_down_origin = target_position + Vector3(0, 1, 0)
	var ray_down_end = target_position + Vector3(0, -3, 0)
	var query_down = PhysicsRayQueryParameters3D.create(ray_down_origin, ray_down_end)
	var result_down = space_state.intersect_ray(query_down)

	# Raycast vers l'avant et vers le bas pour détecter les montées
	var ray_forward_origin = target_position + Vector3(0, 1, 0)
	var ray_forward_end = target_position + slime.transform.basis.z * 2 + Vector3(0, -3, 0)
	var query_forward = PhysicsRayQueryParameters3D.create(ray_forward_origin, ray_forward_end)
	var result_forward = space_state.intersect_ray(query_forward)

	# Si le sol est détecté et qu'on ne dash pas vers le bas, ajuster la hauteur
	if result_down:
		target_position.y = result_down.position.y + 0.1  # Ajuste la hauteur du slime pour coller au sol
	elif result_forward:
		target_position.y = result_forward.position.y + 0.1  # Ajuste la hauteur si une montée est détectée
	
	#if result_down:
		#print("✅ Sol détecté en bas à :", result_down.position)
	#elif result_forward:
		#print("🔄 Montée détectée en avant à :", result_forward.position)
	#else:
		#print("❌ Aucun sol détecté ! Problème possible !")


	return target_position
#---
func stop_dash():
	start_time = 0
	#print("Stop dash")
	state_chart.send_event("IsIdle")
	disable_attack_area(attack_area)
#endregion

#region Items Region
func drop_health_item(position : Vector3) -> void :
	#print("I'm calling the function")
	if not health_item_scene or not slime:
		return

	#
	#if not slime.is_inside_tree() :
		#print("Pas dans l'arbre")
		#return
		
	if randf() <= drop_chance :
		#print("Devrait faire apparaitre l'item")
		var health_item_instance = health_item_scene.instantiate()
		
		get_tree().current_scene.add_child(health_item_instance)
		health_item_instance.global_transform.origin = position
#endregion
##Animation functions

	
#----------------------------------------------
##Vfx functions


#region SFX Region
#----------------------------------------------
##Sfx functions

func launch_slime_step_sound() -> void:
	
	var footstep_manager = get_tree().get_first_node_in_group("FootStepManager")
	#print("Je suis dans launch_slime_step")
	
	if footstep_manager:
		footstep_manager.request_footstep(self)  # Envoie le slime lui-même
		#print("Je lance la request footstep")

#endregion

	
#----------------------------------------------


func _on_random_state_processing(delta: float) -> void:
	# Vérifie si on a atteint le point aléatoire actuel ou si la navigation est terminée
	if slime.global_position.distance_to(random_point_navmesh) < 0.5 or nav_agent.is_navigation_finished():
		generate_random_navmesh_point()  # Génère un nouveau point sur le navmesh
		_restart_target_timer()  # Redémarre le timer
	activate_pre_explosion_mode()
	# Déplacer vers le point généré via NavigationAgent3D
	can_move = true
	move(random_point_navmesh, delta)  # <-- Ça garde ton move() existant

	var horizontal_velocity = slime.velocity
	horizontal_velocity.y = 0

	if horizontal_velocity.length() > 0.01:
		slime.look_at(slime.global_position + horizontal_velocity, Vector3.UP)

	# Vérifie la distance avec la cible (le joueur)
	distance_to_target = check_distance_to_target(player)
	
	if distance_to_target <= attack_range and attack_cool_down <= 0:
		activate_pre_attack_mode()
	elif attack_cool_down > 0:
		activate_idle_mode()

	# Animation du slime en déplacement
	animation_player.play("Slime|Walk")


func generate_random_navmesh_point() -> void:
	# Vérifie si le slime est bien sur une carte avec un NavMesh
	var navigation_map: RID = slime.get_world_3d().navigation_map
	if navigation_map.is_valid():
		# Génère un point aléatoire sur le NavMesh avec layer 1 et non-uniforme
		random_point_navmesh = NavigationServer3D.map_get_random_point(navigation_map, 1, false)
		
		# Vérifie que le point généré est bien valide
		#if random_point_navmesh != Vector3.ZERO:
			#print("Nouvelle target: ", random_point_navmesh)
		#else:
			#print("Échec de la génération du point, on garde l'ancien")
	else:
		# Sécurité si pas de NavMesh, on garde sa position actuelle
		random_point_navmesh = slime.global_position


func _restart_target_timer():
	# Crée un timer qui va forcer un changement de cible après X secondes
	get_tree().create_timer(time_before_new_target).timeout.connect(_force_new_target, CONNECT_ONE_SHOT)


func _force_new_target():
	#print("Forçage d’un nouveau point après timeout!")
	generate_random_navmesh_point()
	_restart_target_timer()  # Relance le timer pour le prochain cycle


func _on_pre_explosion_state_physics_processing(delta: float) -> void:
	can_move = true
	movement_speed = 12
	move(player.position,delta)
	animation_player.play("Slime|Walk")
	
	look_at_target_or_movement(slime, player, slime.velocity, 10.0)
	pre_attack_indicator.visible = true
	distance_to_target = check_distance_to_target(player)
	
	if distance_to_target <= 1 :
		
		send_event_state_chart("IsExplosing")
	

	#print("Je suis dans pre explosion")


func _on_explosion_state_entered() -> void:
	print("Je suis dans explosion")
	explosion()


	


func explosion() -> void : 
	death(slime,pre_explosion_duration)
	blink(slime_body, pre_explosion_duration)
	pre_attack_indicator.visible = false
	attack_indicator.visible = true
	await get_tree().create_timer(pre_explosion_duration).timeout

	explosion_area.visible = true
	explosion_area.monitorable = true
	explosion_area.monitoring = true

	make_zone_damages(explosion_area, explosion_damage)
	
	instantiate_vfx(slime.position, explosion_vfx)

func _on_pre_explosion_state_exited() -> void:
	pre_attack_indicator.visible = false


func _on_death_explosion_state_entered() -> void:
	print("Je suis dans death explosion")
	knockback(player_position)
	explosion()
	


func _on_hunt_state_exited() -> void:
	pre_attack_indicator.visible = false
