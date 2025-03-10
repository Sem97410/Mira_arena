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
#Mesh variables

#----------------------
#Fight variables

#----------------------
#Movement variables

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


func _process(delta: float) -> void:
	can_move = true
	
	target_position = calculate_destination(target_entity)  #in the final code, the target_entity will change base on the state (could be : player, wander_point, patrol point, flee_point )
	
	move(target_position, delta)

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

#----------------------------------------------
##Animation functions

	
#----------------------------------------------
##Vfx functions


#----------------------------------------------
##Sfx functions


	
#----------------------------------------------
