extends Node

class_name PlayerMovementScript

# -------------------------------------
## SUMMARY
#Handle the physical movement of the player
#handle player rotation

# -------------------------------------
## REFERENCES
#Resources
@export var player_movement_resource : PlayerMovementResource



# -----------------
#Nodes
@export var player : CharacterBody3D
@export var animation_tree : AnimationTree

@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

# -----------------
#State
var direction_vector_input: Vector2
@onready var can_move : bool = true
@onready var charge_attack_mode : bool = false

# -----------------
#Values
@onready var temps_player_speed : float = 6

var last_rotation_angle : float = 0.0

func _physics_process(_delta: float) -> void:
	
	move_the_character()
	charge_attack_movement_mode()



	
func move_the_character() -> void: 
	
	if can_move and not charge_attack_mode :
		# Get inputs controle
		direction_vector_input= Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var player_movement_direction: Vector3 = Vector3(direction_vector_input.x, 0, direction_vector_input.y).normalized()
		var input_strength: float = direction_vector_input.length() #Input magnetude (from 0 to 1)
		

		if direction_vector_input.length() > 0.2:
			# Apply movement
			player.velocity.x = player_movement_direction.x * temps_player_speed * input_strength  #Square length ( a regarder)
			player.velocity.z = player_movement_direction.z * temps_player_speed * input_strength

			# Rotation of the character in the direction of the movement
			var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
			player.rotation.y = player_rotation_angle
		else:
			# Arrêter immédiatement le joueur si aucune touche n'est pressée
			player.velocity.x = 0
			player.velocity.z = 0

	# Appliquer le mouvement au joueur

		player.move_and_slide()



func charge_attack_movement_mode() -> void : 
	
	if charge_attack_mode:
		
		direction_vector_input= Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var player_movement_direction: Vector3 = Vector3(direction_vector_input.x, 0, direction_vector_input.y).normalized()
		var input_strength: float = direction_vector_input.length() #Input magnetude (from 0 to 1)
		
		#
		## Rotation of the character in the direction of the movement
		#var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
		#player.rotation.y = player_rotation_angle
		 # Mise à jour de la rotation uniquement si il y a une entrée significative
		if input_strength > 0.001:  # Utiliser un petit seuil plutôt que zéro
			var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
			player.rotation.y = player_rotation_angle
			last_rotation_angle = player_rotation_angle
		else:
			# Maintenir la dernière orientation connue
			player.rotation.y = last_rotation_angle
