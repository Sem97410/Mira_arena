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
#general variables
@export var slime : CharacterBody3D

#----------------------
#Health variables


#----------------------
#Mesh variables

#----------------------
#Fight variables

#----------------------
#Movement variables

#----------------------
#Animation variables

@export var death_animation_duration : float
#----------------------
#Vfx variables

#----------------------
#Sfx variables

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##FUNCTIONS

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
func calculate_destination(target_destination : Vector3):
	#Get every kind of destination target and randomly chose one of them as
	#target destination
	pass
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
