extends CharacterBody3D
class_name BaseEnemy

#----------------------------------------------
##SUMMARY
#This script is suppose to be the base of every 
#kind of enemy that we will have in the game
#It is composed of different functions that will
#be use in the creation of other entity 

##WARNING this code is not suppose to be on an
#entity. But other enemy entity must inherite
#from it
#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##VARIABLES
#----------------------
@export_category("General variables")

#general variables

@export var slime : CharacterBody3D			
@export var nav_agent : NavigationAgent3D	# Ref to the NavigationAgent3D
var player : CharacterBody3D

#----------------------
@export_category("Health variables")

#Health variables

var current_health_point : float
var is_invincible : bool

#----------------------
#Mesh variables

#----------------------
#Fight variables

#----------------------
@export_category("Movement variables")

#Movement variables

var can_move : bool
@export var movement_speed : float
@export var movement_interpolate_strength : float

#----------------------
#Animation variables

#----------------------
#Vfx variables

#----------------------
#Sfx variables

#--------------------------------------------------------------------------------------------
#--------------------------------------------------------------------------------------------

##FUNCTIONS

#----------------------------------------------
##Health functions

func take_damage(damage : float) -> void : 
	current_health_point -= damage
	knockback()
#---
func activate_after_damage_invincibility(invincibility_duration : float) -> void :
	is_invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	is_invincible = false
#---
func death(entity : CharacterBody3D, death_animation_duration : float) : 
	freeze_movement()
	await get_tree().create_timer(death_animation_duration).timeout
	entity.queue_free()
	
#----------------------------------------------
##Mesh functions

func blink(entity_mesh : MeshInstance3D, blink_duration : float) -> void:
	#Start the blink for "Entity"
	await get_tree().create_timer(blink_duration).timeout
	#Stop the blink for "entity"
#---
func hide_mesh(entity_mesh : MeshInstance3D) -> void : 
	entity_mesh.visible = false
#---
func show_mesh(entity_mesh : MeshInstance3D) -> void : 
	entity_mesh.visible = true

#----------------------------------------------
##Fight functions

func activate_attack_area(area : Area3D, attack_duration : float) -> void:
	area.enable = true
	await get_tree().create_timer(attack_duration).timeout
	area.enable = false
	
#----------------------------------------------
##Movement functions

func move(target : Vector3, delta : float) -> void:
	#print("Move function is being called")


	if not can_move :
		return
	else:
		#move to target
		nav_agent.target_position = target
		var current_position = slime.global_position # position actuelle de l'ennemi
		var next_position = nav_agent.get_next_path_position() # prochaine position de l'ennemi
		var new_velocity = (next_position - current_position).normalized() * movement_speed # calcul la nouvelle vitesse de l'ennemi
		#associe la nouvelle vitesse de l'ennemy a la velocity du charracter body utilisation d'un lerp pour fluidifier le mouvement
		slime.velocity = slime.velocity.lerp(new_velocity,movement_interpolate_strength * delta) 




		slime.move_and_slide()


#---
func entity_rotation() -> void : 
	#Rotation logic
	pass
	
	
#---
func look_at_player(player : CharacterBody3D, look_at_range : float) -> void : 
	#if player is in range
	look_at(player.position)
#---
func knockback() -> void : 
	#Knockback logic
	pass
#---
func freeze_movement() -> void :
	can_move = false
#---
func unfreeze_movement():
	can_move = true

#----------------------------------------------
##Animation functions

func play_animation(base_state_machne : AnimationNodeStateMachinePlayback, animation_name : String) -> void:
	base_state_machne.travel(animation_name)
	
#----------------------------------------------
##Vfx functions

func instantiate_vfx(position : Vector3, vfx : PackedScene) -> void : 
	#Instantiate logic
	pass

#----------------------------------------------
##Sfx functions

func play_sound(stream_player : AudioStreamPlayer) -> void : 
	stream_player.play()

#----------------------------------------------
