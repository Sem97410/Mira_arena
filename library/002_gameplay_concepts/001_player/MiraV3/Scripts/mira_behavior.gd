extends CharacterBody3D

# --------------------------------------------------
## SUMMARY
#This script will handle every aspect of Mira's behavior
# --------------------------------------------------

# -------------------------------------
## REFERENCES

#NODES

@export_category("General")

#Animations variables
@export_group("Animation variables")
@export var animation_tree : AnimationTree
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

#---

#States variables
@export_group("States variables")
@export var state_chart : StateChart

#---

#Meshes variables
@export_group("Meshes variables")
@export var aura_mesh : MeshInstance3D

var direction_vector_input: Vector2
@onready var can_move : bool = true
@onready var charge_attack_mode : bool = false

#---

#Camera variables
@export_group("Camera")
@export var camera : Camera3D


# ----------------

# MOVEMENT
@export_category("Movement ")

#Movement variables
@export_group("Movement variables")
@export var player_speed : float = 6.0

#---

#Jump variables
@export_group("Jump variables")
@export var jump_strength : float = 7.5

#---

#Dash variables
@export_group("Dash variables")
@export_subgroup("Dash general values")
@export var dash_duration: float = 0.2 #In second
@export var latence_between_dash : float = 3.0

@export_subgroup("Dash movement values")
@export var dash_length : float
@onready var start_time : int = 0 #When the dash start
@onready var dash_countdown : float = 0.0

@export_subgroup("Player position")
var start_position : Vector3 #Begining of the dash
var destination_target : Vector3 #End of the dash

var was_in_air = false  # Pour savoir si on était en l'air avant le dash

#---

#Gravity variables
@export_group("Gravity variables")
@export var gravity_strength : float = 2.0
#---
var last_rotation_angle : float = 0.0

# ----------------

#VFX
@export_category("VFX")

#Foot step variables
@export_group("Foot step VFX")
@export var foot_step_vfx : PackedScene
@export_subgroup("Storage")
@export var movement_vfx_storage : Node

#---

# ----------------

#SFX
@export_category("SFX")

#Foot step variables
@export_group("Foot step SFX")
@export var mira_step : AudioStreamPlayer3D
@export_subgroup("Foot step type")
@export var footstep_sounds : Array[AudioStream]

#---

# ----------------

#Animations





# --------------------------------------------------------------------------

# BASE FUNCTIONS

# --------------------------------------------------------------------------

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	#assign_movement_blend_position()  #Create a blend between idle walk and run
	#move_the_character()
	#charge_attack_movement_mode()
	#launch_in_the_air_animation()
	

# --------------------------------------------------------------------------

# STATES FUNCTIONS

# --------------------------------------------------------------------------

func _on_idle_state_entered() -> void:
	base_state_machine.travel("MovementBlendSpace")
	assign_movement_blend_position()  #Create a blend between idle walk and run
	#print("Je viens d'entrer dans le state idle")

#---

func _on_idle_state_processing(delta: float) -> void:
	move_the_character()
	activate_movement_state()
	activate_in_the_air_state()

#---

func _on_movement_state_entered() -> void:
	print("Je viens d'entrer dans le state movement")

#---
func _on_movement_state_processing(delta: float) -> void:
	base_state_machine.travel("MovementBlendSpace")
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	activate_idle_state()
	activate_in_the_air_state()

#---

func _on_in_the_air_state_processing(delta: float) -> void:
	move_the_character()
	is_in_the_air()
	
	if is_on_floor():
		activate_idle_state()
		activate_movement_state()
 
# --------------------------------------------------------------------------

# STATES ACTIVATIONS FUNCTIONS

# --------------------------------------------------------------------------

func send_event_state_chart(event_name : String)-> void :
	state_chart.send_event(event_name)
	
#---

func activate_idle_state()-> void : 
	if velocity.length() <= 0 :
		send_event_state_chart("IsIdle")

#---

func activate_movement_state()-> void : 
	if velocity.length() > 0 :
		send_event_state_chart("IsMoving")

#---

func activate_in_the_air_state() -> void : 
	if not is_on_floor() or Input.is_action_just_pressed("jump"):
		send_event_state_chart("IsInTheAir")

#---

func is_in_the_air() -> void : 
	base_state_machine.travel("InTheAir")

# --------------------------------------------------------------------------

## MOVEMENT

func add_gravity(delta : float) -> void : 
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_strength

#---

func move_the_character() -> void:
	if can_move and not charge_attack_mode:
		# Get inputs controle
		direction_vector_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var player_movement_direction: Vector3 = Vector3(direction_vector_input.x, 0, direction_vector_input.y).normalized()
		var input_strength: float = direction_vector_input.length()

		# Apply horizontal movement
		if direction_vector_input.length() > 0.2:
			velocity.x = player_movement_direction.x * player_speed * input_strength
			velocity.z = player_movement_direction.z * player_speed * input_strength

			# Rotation of the character
			var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
			rotation.y = player_rotation_angle
		else:
			velocity.x = 0
			velocity.z = 0

		# Jump logic (Y axis)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump_the_character()

	# Apply movement
	move_and_slide()

#---

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
			rotation.y = player_rotation_angle
			last_rotation_angle = player_rotation_angle
		else:
			# Maintenir la dernière orientation connue
			rotation.y = last_rotation_angle

#---

func jump_the_character() -> void : 
	velocity.y = jump_strength

#---

func launch_in_the_air_animation() -> void : 
	if not is_on_floor():
		base_state_machine.travel("Fly")
		aura_mesh.visible = false
	elif is_on_floor() :
		base_state_machine.travel("MovementBlendSpace")
		aura_mesh.visible = true

#---

func modify_animation_time_scale() -> void : 
	
	if velocity.length() >= 0.1 && velocity.length() <= 2:
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 1.5)
		
	else :
		animation_tree.set("parameters/MiraAnimation/MovementStateMachine/MovementBlendTree/TimeScale/scale", 1)

#---

func assign_movement_blend_position() -> void : 
	animation_tree.set("parameters/MiraAnimations/MovementBlendSpace/blend_position", velocity.length())
	animation_tree.set("parameters/MiraAnimations/Combo1BlendTree/MovementBlendSpace/blend_position",velocity.length())
	animation_tree.set("parameters/MiraAnimations/Combo2BlendTree/MovementBlendSpace/blend_position", velocity.length())
	animation_tree.set("parameters/MiraAnimations/Combo3BlendTree/MovementBlendSpace/blend_position",velocity.length())

#---

func enable_movement() -> void : 
	can_move = true

#---

func disable_movement() -> void : 
	can_move = false

#---

# --------------------------------------------------------------------------

## VFX
func instantiate_foot_step_vfx() -> void : 
	var vfx_instance = foot_step_vfx.instantiate()  # Crée une instance du VFX
	movement_vfx_storage.add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	vfx_instance.global_transform = global_transform  # Place le VFX exactement où est le joueur
	play_random_footstep()

#---

# --------------------------------------------------------------------------

## SFX
func play_random_footstep() -> void:
	if footstep_sounds.is_empty():
		print("Aucun son de pas assigné !")
		return
	
	var random_index = randi() % footstep_sounds.size()  # Choisir un son aléatoire
	mira_step.stream = footstep_sounds[random_index]
	mira_step.pitch_scale = randf_range(0.9, 1.1)  # Légère variation du pitch pour plus de naturel
	mira_step.play()

#---
