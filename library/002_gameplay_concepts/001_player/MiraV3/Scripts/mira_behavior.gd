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
var _previous_position: Vector3

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
var _idle_timer := 0.0
var _input_strength := 0.0
var _real_speed := 0.0


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

@export_subgroup("FOV")
@onready var base_FOV : float = 75.0
@onready var dash_FOV : float = 90.0

@export_subgroup("Action line")
@export var action_line_sprites : AnimatedSprite2D

var was_in_air = false  # Pour savoir si on était en l'air avant le dash

var dash_cooldown_after_stop := 0.0


#---

#Gravity variables
@export_group("Gravity variables")
@export var gravity_strength : float = 2.0
#---
var last_rotation_angle : float = 0.0

# ----------------

#ATTACK

#Light attack

#---

#Animation combo
@onready var animation_combo_index : int = 1

#---

#Buffer
@onready var combo_window_is_active : bool = false
@onready var light_attack_input_was_pressed : bool = false
@onready var post_attack_windows_duration : float = 2.0
@onready var post_attack_windows_timer : float = 0.0
@onready var is_in_post_attack_phase : bool = false

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



# --------------------------------------------------------------------------

# BASE FUNCTIONS

# --------------------------------------------------------------------------

func _ready():
	_previous_position = global_position
	
func _physics_process(delta: float) -> void:
	add_gravity(delta)
	decrease_dash_countdown(delta)
	update_movement_tracking(delta)
	
	if dash_cooldown_after_stop > 0:
		dash_cooldown_after_stop -= delta	
	
	#print("Light attack input was pressed is : ", light_attack_input_was_pressed)
	
	if post_attack_windows_timer > 0 :
		is_in_post_attack_phase = true
	else :
		is_in_post_attack_phase = false
		
	if is_in_post_attack_phase :
		post_attack_windows_timer-= delta
		
		if post_attack_windows_timer <= 0:
			combo_window_is_active = false
			reset_animation_index()
			is_in_post_attack_phase = false
			
			activate_idle_state()
			activate_movement_state()
	#print("Index combo is :", animation_combo_index)
	
	print("Combo index is  : ", animation_combo_index)

# --------------------------------------------------------------------------

# STATES FUNCTIONS

# --------------------------------------------------------------------------

func _on_idle_state_entered() -> void:
	base_state_machine.travel("MovementBlendSpace")
	
	#print("Je viens d'entrer dans le state idle")


func _on_idle_state_processing(delta: float) -> void:
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	activate_movement_state()
	activate_in_the_air_state()
	activate_dash_state()
	activate_light_attack_state()

#---

#func _on_movement_state_entered() -> void:
	#print("Je viens d'entrer dans le state movement")

func _on_movement_state_processing(delta: float) -> void:
	base_state_machine.travel("MovementBlendSpace")
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	activate_idle_state()
	activate_in_the_air_state()
	activate_dash_state()
	activate_light_attack_state()

#---
#func _on_in_the_air_state_entered() -> void:
	#print("I'm in the state In the air")
	
	
func _on_in_the_air_state_processing(delta: float) -> void:
	move_the_character()
	activate_in_the_air_state()
	activate_dash_state()

	
	if is_on_floor():
		activate_idle_state()
		activate_movement_state()

#---

func _on_dash_state_entered() -> void:
	#print("Je suis entré dans le state dash")
	initiate_dash()
	start_dash()




func _on_dash_state_physics_processing(delta: float) -> void:
	execute_dash() #Launch the dash if all conditions are met
	activate_light_attack_state()
	


func _on_dash_state_exited() -> void:
	assign_movement_blend_position()

#---


func _on_light_attack_state_entered() -> void:
	#print("Enter LightAttack state")
	launch_light_attack()

func _on_light_attack_state_processing(delta: float) -> void:
	#print("I'm in light attack state processing")
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	#activate_idle_state()
	#activate_movement_state()
	if Input.is_action_just_pressed("light_attack"):
		#print("Light attack input was pressed")
		light_attack_input_was_pressed = true

#func _on_light_attack_state_physics_processing(delta: float) -> void:
	##print("I'm in light attack physical state")


#---

# --------------------------------------------------------------------------

# STATES ACTIVATIONS FUNCTIONS

# --------------------------------------------------------------------------

func send_event_state_chart(event_name : String)-> void :
	state_chart.send_event(event_name)
	
#---

func activate_idle_state()-> void : 
	if _input_strength <= 0.1 and _real_speed < 0.05 and _idle_timer >= 0.3:
		send_event_state_chart("IsIdle")
		#print("Enter in idle state")

#---

func activate_movement_state()-> void : 
	if _input_strength > 0.1 and _real_speed > 0.1:
		send_event_state_chart("IsMoving")
		#print("Enter in movement state")


#---

func activate_in_the_air_state() -> void : 
	if start_time > 0 or dash_cooldown_after_stop > 0:
		return  # Ne pas activer le state "InTheAir" pendant ou juste après un dash

	if not is_on_floor() or Input.is_action_just_pressed("jump"):
		send_event_state_chart("IsInTheAir")

#---

func activate_dash_state() -> void : 
	if Input.is_action_just_pressed("dash"):
		send_event_state_chart("IsDashing")

#---

func is_in_the_air_state() -> void : 
	base_state_machine.travel("Jump")

#---

func activate_light_attack_state() -> void : 
	if Input.is_action_just_pressed("light_attack"): 
		send_event_state_chart("IsLightAttacking")
		is_in_post_attack_phase = false
		combo_window_is_active = false
		light_attack_input_was_pressed = false
		

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

# --------------------------------------------------------------------------

## JUMP

func jump_the_character() -> void : 
	velocity.y = jump_strength

# --------------------------------------------------------------------------

## IN THE AIR
func launch_in_the_air_animation() -> void : 
	if not is_on_floor():
		base_state_machine.travel("Fly")
		aura_mesh.visible = false
	elif is_on_floor() :
		base_state_machine.travel("MovementBlendSpace")
		aura_mesh.visible = true

# --------------------------------------------------------------------------

## ANIMATION

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
# Updates input, speed, and idle timer to track player movement state.

func update_movement_tracking(delta: float) -> void:
	# Player input
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	_input_strength = input_vector.length()

	# Vitesse réelle
	var displacement = global_position - _previous_position
	_real_speed = displacement.length() / delta
	_previous_position = global_position

	# Timer Idle
	if _input_strength == 0 and _real_speed < 0.05:
		_idle_timer += delta
	else:
		_idle_timer = 0.0

#---

func enable_movement() -> void : 
	can_move = true

#---

func disable_movement() -> void : 
	can_move = false

# --------------------------------------------------------------------------

## DASH

func initiate_dash() -> void : 

	launch_dash_animation()
	dash_countdown = latence_between_dash

#---

func decrease_dash_countdown(delta : float ) -> void : 
	if dash_countdown > 0:
		dash_countdown -= delta

#---

func start_dash():

	##Destination target = A position in front of the player 
	
	start_position = position
	start_time = Time.get_ticks_msec()
	destination_target = position + transform.basis.z * dash_length

	# Vérifie si le joueur était en l'air avant de dasher
	was_in_air = not is_on_floor()
	
#---

func execute_dash():
	if start_time > 0:
		var elapsed_time = (Time.get_ticks_msec() - start_time) / 1000.0
		var t = elapsed_time / dash_duration

		if t >= 1:
			stop_dash()
			return

		# Interpolation entre le point de départ et la destination
		var target_position = start_position.lerp(destination_target, t)
		var dash_direction = (destination_target - start_position).normalized()

		# ⚠️ NE PAS AJUSTER LA HAUTEUR SI ON DASH DANS LES AIRS ⚠️
		if not was_in_air:
			if dash_direction.y >= 0:
				target_position = adjust_height_to_ground(target_position)
			# Si on dash vers le bas, on laisse la physique gérer et on ajuste plus tard

		# Déplacement avec collision
		var step = target_position - global_transform.origin
		var coll = move_and_collide(step)

		if coll:
			stop_dash()

#---

func adjust_height_to_ground(target_position: Vector3) -> Vector3:
	var space_state = get_world_3d().direct_space_state

	# Raycast vers le bas (pour coller au sol si nécessaire)
	var ray_down_origin = target_position + Vector3(0, 1, 0)
	var ray_down_end = target_position + Vector3(0, -3, 0)
	var query_down = PhysicsRayQueryParameters3D.create(ray_down_origin, ray_down_end)
	var result_down = space_state.intersect_ray(query_down)

	# Raycast vers l'avant et vers le bas pour détecter les montées
	var ray_forward_origin = target_position + Vector3(0, 1, 0)
	var ray_forward_end = target_position + transform.basis.z * 2 + Vector3(0, -3, 0)
	var query_forward = PhysicsRayQueryParameters3D.create(ray_forward_origin, ray_forward_end)
	var result_forward = space_state.intersect_ray(query_forward)

	# Si le sol est détecté et qu'on ne dash pas vers le bas, ajuster la hauteur
	if result_down:
		target_position.y = result_down.position.y + 0.1  
	elif result_forward:
		target_position.y = result_forward.position.y + 0.1  

	return target_position

#---

func stop_dash():
	start_time = 0
	dash_cooldown_after_stop = 0.1  # 250 ms de protection post-dash
	send_event_state_chart("IsMoving")
	
#---

func modify_fov_with_tween() -> void : 
	if Input.is_action_just_pressed("dash"):
		#print("Modification of the FOV")
		var tween = create_tween()

		tween.tween_property(camera, "fov", dash_FOV, 0.1)
	
		await get_tree().create_timer(0.3).timeout
		
		var tween_back = get_tree().create_tween()
		tween_back.tween_property(camera, "fov", base_FOV, 0.1)
#---

func launch_action_line() -> void : 
	
	action_line_sprites.play("Action lines")
	action_line_sprites.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	action_line_sprites.visible = false
	action_line_sprites.stop()

#---

func launch_dash_animation() -> void : 
	base_state_machine.travel("Dash")

# --------------------------------------------------------------------------

## ATTACK

#Light attack

func launch_light_attack() -> void:
	#print("Launch light attack here")
	light_attack_input_was_pressed = false
	combo_window_is_active = false
	var target_state = "Combo" + str(animation_combo_index) + "BlendTree"
	#print("Lance animation :", target_state)
	base_state_machine.travel(target_state)
	
	
#---

func set_animation_index_values(index_values : int) -> void: 
	animation_combo_index = index_values


func reset_animation_index():
	print(" RESET combo depuis handle_reset_animation_combo_index()")
	animation_combo_index = 1

func toggle_combo_windows(status : bool) -> void : 
	combo_window_is_active = status
	
func activate_combo_if_clicked_during_combo_window() -> void : 
	if light_attack_input_was_pressed and combo_window_is_active :
		print("I'm inside the windows")
		launch_light_attack()
	else:
		launch_countdown_for_combo_windows()

func launch_countdown_for_combo_windows() -> void : 
	print("Start of the countdown")
	post_attack_windows_timer = post_attack_windows_duration
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
