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
@export var state_chart : StateChart

#----------------------
@export_category("Health variables")

#Health variables

var current_health_point : float
@export var max_health_point : float
var is_invincible : bool


var is_knockback_active : bool = false  # Knockback en cours ?
var knockback_velocity : Vector3 = Vector3.ZERO  # Stocke la force actuelle du knockback
var knockback_force : float = 15.0  # Intensité du knockback
var knockback_vertical_boost : float = 5.0  # Hauteur de l'effet "en cloche"
var knockback_decay : float = 5.0  # Vitesse de réduction du knockback
var knockback_duration : float = 0.5  # Durée totale du knockback
var knockback_timer : float = 0.0  # Temps écoulé depuis le début du knockback

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

@onready var stored_safe_velocity = Vector3.ZERO

var gravity: float = 9.8  # Force de la gravité
@export var max_fall_speed: float = 100.0  # Vitesse maximale de chute
var vertical_velocity: float = 0.0  # Stocke la vitesse verticale

#----------------------
#Animation variables
@export var animation_player : AnimationPlayer
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
	print("New slime take damage")
	
	current_health_point -= damage
	state_chart.send_event("IsHit")

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
	# Vérifie si le slime peut bouger
	if not can_move:
		return
	
	# Définit la cible dans le NavigationAgent
	nav_agent.target_position = target
	
	# Récupère la position actuelle et la prochaine position du chemin
	var current_position = slime.global_position
	var next_position = nav_agent.get_next_path_position()
	
	# Calcule la nouvelle direction normale vers la cible
	var new_velocity = (next_position - current_position).normalized() * movement_speed

	# Mélange le déplacement naturel avec le safe_velocity (évite les collisions)
	var final_velocity = new_velocity.lerp(stored_safe_velocity, 0.5)  # Ajuste le 0.5 si besoin
	
	# Enregistre cette vélocité dans le NavigationAgent
	nav_agent.set_velocity(final_velocity)




#---
func entity_rotation() -> void : 
	#Rotation logic
	slime.look_at(player.global_position)# la fonction look_at(récupère la position du joueur)
	
	
#---
func look_at_target_or_movement(entity: Node3D, target: Node3D, movement_direction: Vector3, threshold_distance: float) -> void:
	var current_position: Vector3 = entity.global_position
	var target_position: Vector3 = target.global_position

	# Vérifier si l'entité et la cible ne sont pas exactement au même endroit
	if current_position.is_equal_approx(target_position):
		return  # Ne fait rien si la position est identique, évite l'erreur

	# Calculer la distance à la cible
	var distance_to_target: float = current_position.distance_to(target_position)

	# Déterminer la direction vers laquelle regarder
	var look_at_position: Vector3
	if distance_to_target < threshold_distance:
		look_at_position = target_position
	else:
		look_at_position = current_position + movement_direction.normalized()

	# Vérifier que le vecteur de direction est valide
	if not current_position.is_equal_approx(look_at_position):
		var up_vector: Vector3 = Vector3.UP

		# Si la direction de visée est trop colinéaire avec UP, on ajuste
		if abs((look_at_position - current_position).normalized().dot(up_vector)) > 0.99:
			up_vector = Vector3.FORWARD  # Alternative pour éviter l'erreur

		entity.look_at(look_at_position, up_vector)


#--- A DOCUMENTER
func knockback(attacker_position: Vector3) -> void:
	# Si le knockback est déjà actif, on l'ignore
	if is_knockback_active:
		return

	# 📌 Calculer la direction opposée à l'attaquant
	var direction = (slime.global_position - attacker_position).normalized()
	direction.y = 0  # On annule le Y pour éviter un mouvement vertical involontaire

	# 📌 Appliquer une force initiale (recul + montée en cloche)
	knockback_velocity = direction * knockback_force  
	knockback_velocity.y = knockback_vertical_boost  # Donne une poussée vers le haut pour le mouvement en cloche

	# 📌 Activer le knockback
	is_knockback_active = true
	knockback_timer = knockback_duration  

	# 📌 Empêcher le mouvement normal pendant le knockback
	can_move = false  

	# 📌 Envoyer un signal au StateChart pour rester en `HitReaction`
	state_chart.send_event("IsHit")

	# 📌 Faire regarder l'ennemi dans la direction opposée
	slime.look_at(slime.global_position - direction)

	# Debugging
	print("🚀 Knockback lancé ! Velocity :", knockback_velocity)





#--- A DOCUMENTER
func apply_knockback_movement(delta: float) -> void:
	if is_knockback_active:
		# 📌 Appliquer la vélocité du knockback
		slime.velocity = knockback_velocity

		# 📌 Appliquer la gravité pendant le knockback
		knockback_velocity.y -= gravity * delta  
		knockback_velocity.y = max(knockback_velocity.y, -max_fall_speed)  # Limite la chute

		# 📌 Réduire progressivement la vélocité horizontale pour un arrêt naturel
		knockback_velocity.x = lerp(knockback_velocity.x, 0.0, knockback_decay * delta)
		knockback_velocity.z = lerp(knockback_velocity.z, 0.0, knockback_decay * delta)

		# 📌 Réduire le timer
		knockback_timer -= delta

		# 📌 Appliquer le mouvement avec collision
		slime.move_and_slide()

		# 📌 Vérifier si le knockback doit s'arrêter
		if knockback_timer <= 0 and slime.is_on_floor():
			knockback_velocity = Vector3.ZERO
			is_knockback_active = false
			can_move = true  # 🔥 Réautoriser le mouvement normal
			
			animation_player.play("Slime|hit")
			await get_tree().create_timer(1.4).timeout
			# 🔥 Revenir à Idle SEULEMENT si le slime touche bien le sol
			state_chart.send_event("IsIdle")
			print("⏹ Knockback terminé.")

#---

func freeze_movement() -> void :
	can_move = false
#---
func unfreeze_movement():
	can_move = true
#---
func apply_gravity(delta: float):
	if not slime.is_on_floor():  
		vertical_velocity -= gravity * delta  # Applique la gravité
		vertical_velocity = max(vertical_velocity, -max_fall_speed)  # Limite la vitesse de chute
	else:
		vertical_velocity = 0  # Réinitialise la vitesse si au sol

	slime.velocity.y = vertical_velocity  # Met à jour la vélocité tout le temps



#----------------------------------------------
##Animation functions

func play_animation(base_state_machne : AnimationNodeStateMachinePlayback, animation_name : String) -> void:
	base_state_machne.travel(animation_name)
	
#----------------------------------------------
##Vfx functions

func instantiate_vfx(position: Vector3, vfx: PackedScene) -> void:
	if vfx == null:
		print("❌ Erreur : Le VFX est nul, impossible d'instancier.")
		return

	var vfx_instance = vfx.instantiate()
	if not vfx_instance:
		print("❌ Erreur : Impossible d'instancier le VFX.")
		return

	# Ajouter le VFX à la scène AVANT de modifier sa position
	get_tree().current_scene.add_child(vfx_instance)

	# Maintenant, on peut modifier sa position
	vfx_instance.global_position = position
#----------------------------------------------
##Sfx functions

func play_sound(stream_player : AudioStreamPlayer) -> void : 
	stream_player.play()

#----------------------------------------------
