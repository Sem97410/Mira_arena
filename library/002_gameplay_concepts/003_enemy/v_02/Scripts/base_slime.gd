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
var distance_to_target : float 





#----------------------
#Health variables


#----------------------
@export_category("Meshes variables")

#Mesh variables
@export var damage_stars : Node3D
@export var slime_body : Node3D
#----------------------
#Fight variables
@onready var attack_range : float = 3.0
#----------------------
#Movement variables
@onready var can_jump : bool = true

@onready var jump_height = 1.5  # Hauteur du saut
@onready var duration = 0.5  # Temps total du saut
@onready var elapsed_time = 0
@onready var random_point_interval : float = 0.5
var random_point_around_target : Vector3
@onready var is_generating_random_point = false  # Pour éviter les doublons
#----------------------
@export_category("Animation variables")

#Animation variables

@export var death_animation_duration : float

#----------------------
#Vfx variables
@export var death_vfx : PackedScene
#----------------------
@export_category("Debug variables") ## MUST BE DELETE

#Debug variables
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
	var distance_to_target = check_distance_to_target(player)
	
	# Applique le knockback s'il est actif
	apply_knockback_movement(delta)

	#print("Slime Position:", slime.global_position)
	#print("Is on floor:", slime.is_on_floor())


#----------------------------------------------
##Check States functions
func check_distance_to_target(target : Node3D) -> float :
	return global_position.distance_to(target.global_position)
#---
func send_event_state_chart(event_name : String)-> void : 
	state_chart.send_event(event_name)
#---
func activate_hunt_mode() -> void : 
	var distance_to_target = check_distance_to_target(player)
	#print("Distance to target is : ", distance_to_target)
	if distance_to_target > attack_range : 
		#print("Move in hunting mode")
		send_event_state_chart("IsHunting")
#---
func activate_idle_mode() -> void : 
	var distance_to_target = check_distance_to_target(player)
	if distance_to_target <= attack_range : 
		#print("Move in Idle mode")
		send_event_state_chart("IsIdle")
#----------------------------------------------
#----------------------------------------------
##Health functions

func _on_hit_reaction_state_entered() -> void:
	print("I'm in hit reaction!")
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

	
func _on_death_state_entered() -> void:
	slime_body.visible = false
	instantiate_vfx(slime.global_position, death_vfx )
	death(slime, 1.5)
#----------------------------------------------
##Mesh functions


#----------------------------------------------
##Fight functions

func attack_movement(dash_duraton : float, dash_speed : float) -> void: 
	#Make a dash that lasts dash_duration at dash_speed speed
	pass
	
#----------------------------------------------
##Movement functions
func calculate_destination(target: Node3D) -> Vector3:
	if target:
		return target.global_position
	return slime.global_position  # Si la cible est invalide, le slime reste sur place

#---

func create_random_point_around(target: Vector3, range: float) -> Vector3:
	var offset_x = randf_range(-range, range)
	var offset_z = randf_range(-range, range)
	var new_point = Vector3(target.x + offset_x, target.y, target.z + offset_z)
	
	#print("🎯 Nouveau point aléatoire autour du joueur : ", new_point)
	
	return new_point


#---

func get_random_point_around(range: float) -> void:
	if is_generating_random_point:
		return  # Empêche de relancer la fonction si elle est déjà en cours
	
	is_generating_random_point = true  # Marque comme en cours
	await get_tree().create_timer(random_point_interval).timeout
	random_point_around_target = create_random_point_around(player_position, range)
	is_generating_random_point = false  # Marque comme terminé
	
#---

func step_away_from_close_enemy(separation_distance : float):
	#if an enemy si too close, move in the opposite direction
	pass
	
#---

func _on_hunt_state_processing(delta: float) -> void:
	get_random_point_around(3.0)  # Change la cible régulièrement
	can_move = true
	move(random_point_around_target, delta)
	entity_rotation()
	look_at_target_or_movement(slime, player, slime.velocity, 10.0)
	activate_idle_mode()
	animation_player.play("Slime|Walk")

#---

func _on_idle_state_processing(delta: float) -> void:
	can_move = false
	#print("Je suis dans le State 'idle'")
	
	animation_player.play("Slime|idle")
	activate_hunt_mode()
	
#---

func _on_navigation_agent_3d_link_reached(details: Dictionary) -> void:
	#print("J'ai touché un navigation link")
	#print("Au contact du nav link can jump is : ", can_jump)
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

func jump_to_target(start: Vector3, end: Vector3) -> void:
	#print("Suppose to jump")

	elapsed_time = 0.0  # 🔥 Réinitialisation ici

	while elapsed_time < duration:
		#print("Je suis dans le while et ca devrait etre false et c'est  : ", can_jump)
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
		
		var t = elapsed_time / duration  # Normalisation du temps (0 à 1)
		
		# Lerp entre A et B
		var new_position = start.lerp(end, t)
		
		# Ajouter la hauteur du saut avec une parabole
		new_position.y += jump_height * sin(t * PI)
		
		slime.global_transform.origin = new_position

	# 🔥 Attendre un peu avant de réactiver le saut (évite les spams)
	await get_tree().create_timer(0.2).timeout  # Petit délai pour éviter un double trigger

	can_jump = true  # Réactive le saut après un court délai
	#print("Fin de jump to target, can_jump est maintenant : ", can_jump)
	
#----------------------------------------------

##Animation functions

	
#----------------------------------------------
##Vfx functions


#----------------------------------------------
##Sfx functions


	
#----------------------------------------------
