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

@export var state_chart : StateChart
@export var animation_player : AnimationPlayer


#----------------------
#Health variables


#----------------------
#Mesh variables

#----------------------
#Fight variables
@onready var attack_range : float = 3.0
#----------------------
#Movement variables
@onready var can_jump : bool = true
#----------------------
@export_category("Animation variables")

#Animation variables

@export var death_animation_duration : float

#----------------------
#Vfx variables

#----------------------
@export_category("Debug variables") ## MUST BE DELETE

#Debug variables

@export var target_entity : Node3D   #Test that allow me to assign a target with the inspector. In the final code the slime will assign the target through the code

#----------------------

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##FUNCTIONS

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") #Assign the player
	can_move = true


func _process(delta: float) -> void:
	apply_gravity(delta)
	var distance_to_target = check_distance_to_target(player)
	#print("Distance to target is : ", distance_to_target)
	



	if  slime.is_on_floor() :
		print("Il touche le sol")
	

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

func check_if_dead()-> void:
	
	if current_health_point <= 0 : 
		death(slime, death_animation_duration)

	
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
func step_away_from_close_enemy(separation_distance : float):
	#if an enemy si too close, move in the opposite direction
	pass
#---
func _on_hunt_state_processing(delta: float) -> void:
	#print("Je suis dans le State 'hunt'")
	can_move = true
	target_position = calculate_destination(target_entity)  #in the final code, the target_entity will change base on the state (could be : player, wander_point, patrol point, flee_point )
	move(target_position, delta)
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
	print("J'ai touché un navigation link")
	if not can_jump: 
		print("Je peux pas sauter")
		return  # Bloque si un saut est déjà en cours
	
	can_jump = false  # Désactive le saut temporairement
	var start_position = details["link_entry_position"]  # Point A
	var end_position = details["link_exit_position"]    # Point B
	jump_to_target(start_position, end_position)
	print("Accès navigation link")


func jump_to_target(start: Vector3, end: Vector3) -> void:
	var jump_height = 5.0  # Hauteur du saut
	var duration = 1.5  # Temps total du saut
	var elapsed_time = 0.0
	
	print("Suppose to jump")
	
	while elapsed_time < duration:
		await get_tree().process_frame
		elapsed_time += get_process_delta_time()
		
		var t = elapsed_time / duration  # Normalisation du temps (0 à 1)
		
		# Lerp entre A et B
		var new_position = start.lerp(end, t)
		
		# Ajouter la hauteur du saut avec une parabole
		new_position.y += jump_height * sin(t * PI)
		
		slime.global_transform.origin = new_position

	can_jump = true  # Réactive le saut une fois terminé
#----------------------------------------------
##Animation functions

	
#----------------------------------------------
##Vfx functions


#----------------------------------------------
##Sfx functions


	
#----------------------------------------------
