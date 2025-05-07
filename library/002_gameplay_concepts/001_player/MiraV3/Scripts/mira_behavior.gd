extends CharacterBody3D

# --------------------------------------------------
## SUMMARY
#This script will handle every aspect of Mira's behavior
# --------------------------------------------------
@export_multiline var Summary : String
# -------------------------------------
## REFERENCES

#NODES

@export_category("Important")

#---

#Player variable
@export_group("❗Required References❗ ⚠️")
@export_subgroup("Player")
@export var player : CharacterBody3D
@export var aura_mesh : MeshInstance3D #The colored circle effect around the player
@export var player_mesh : Node3D

#---

#Animations variables
@export_subgroup("Animation variables")
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

#---

@export_subgroup("Behavior")
@export var state_chart : StateChart

#---

@export_subgroup("Camera")
@export var camera : Camera3D
@export var camera_behavior_script : CameraBehavior
@export var camera_position: Camera3D

#---

@export_subgroup("HealthBar")
@export var health_bar : ProgressBar
@export var death_pannel : Control
@export var death_pannel_first_button : Button

#---

@export_subgroup("Dash action line")
@export var action_line_sprites : AnimatedSprite2D

#---

@export_subgroup("Light attack")
@export var light_attack_area : Area3D
@export var long_range_collision_shape : CollisionShape3D
@export var short_range_collision_shape : CollisionShape3D
@export var light_attack_vfx_storage : Node
@export var light_attack_combo_1_duration : float
@export var light_attack_combo_2_duration : float
@export var light_attack_combo_3_duration : float
@export var light_attack_combo_4_duration : float
@export var light_attack_combo_5_duration : float

#---

@export_subgroup("Light attack VFX")
@export var combo_1_vfx_scene : PackedScene
@export var combo_2_vfx_scene: PackedScene
@export var base_combo_position : Node3D
@export var combo_3_animation_player : AnimationPlayer
@export var combo_3_vfx : Node3D

#---

@export_subgroup("Light attack SFX")
@export var attack_1_sound : AudioStreamPlayer
@export var attack_2_sound : AudioStreamPlayer
@export var attack_3_sound : AudioStreamPlayer

#---

@export_subgroup("Charged attack")
@export var charge_attack_charging : Node3D
@export var charge_attack_lock_mesh : Node3D
@export var charged_attack_area : Area3D
@export var charged_attack_collision : CollisionShape3D
@export var charged_attack_impact_collision : CollisionShape3D
@export var charged_attack_impact_vfx : PackedScene
@export var charged_attack_impact_vfx_storage : Node3D
@export var charged_attack_impact_vfx_spawn_position : Node3D

@export_subgroup("Charged attack SFX")
@export var charged_attack_sound : AudioStreamPlayer

#Foot step variables
@export_subgroup("Foot step VFX")
@export var foot_step_vfx : PackedScene
@export var movement_vfx_storage : Node

@export_subgroup("Foot step SFX")
@export var mira_step : AudioStreamPlayer3D
@export var footstep_sounds : Array[AudioStream]

# ----------------


#---

#States variables
@export_group("States variables") #Bool that determine if player is in a state or not.
@onready var is_idle : bool = false
@onready var is_moving : bool = false
@onready var is_in_the_air : bool = false
@onready var is_dashing : bool = false
@onready var is_light_attacking : bool = false
@onready var is_charged_attacking : bool = false
@onready var is_recovering : bool = false

@onready var can_transition : bool = true#Allow or not a transition during an animation
@onready var can_move : bool = true #Disable/eneable movement
@onready var charge_attack_mode : bool = false #Disables movement and changes left joystick behavior during a charged attack.

#---

#Movement variables
var direction_vector_input: Vector2 #Used to handle the player's movement in move_the_character()
var _previous_position: Vector3 # used to calculate the real player's speed in update_movement_tracking()

# ----------------

# HEALTH
@export_category("Health")
@export_subgroup("General health values")
@export var player_max_hp : float = 100
@onready var player_current_hp : float = player_max_hp
@onready var is_alive : bool = true

@export_subgroup("Invincibility values")
@onready var blink_interval : float = 0.2
@onready var after_hit_invicibility : bool = false
@export var invicibility_duration : float = 5.0 #base on the number of blink

# ----------------

# MOVEMENT
@export_category("Movement ")

#Movement variables
@export_group("Movement variables")
var player_current_speed : float
@export var player_normal_speed : float = 6.0
@export var player_charged_attack_speed : float = 2.0
#var _idle_timer := 0.0
var _input_strength := 0.0
var _real_speed := 0.0

#---

#Jump variables
@export_group("Jump variables")
@export var jump_strength : float = 7.5

#---
#Dash variables

#Controls dash values as well as various variables used to manage it.
@export_group("Dash variables")
@export_subgroup("Dash general values")
@export var dash_duration: float = 0.2 #In second
@export var latence_between_dash : float = 3.0
@export var dash_length : float


@onready var start_time : int = 0 #When the dash start
@onready var dash_countdown : float = 0.0
var dash_cooldown_after_stop := 0.0

@export_subgroup("Player position")
var start_position : Vector3 #Begining of the dash
var destination_target : Vector3 #End of the dash

@export_subgroup("FOV")
@onready var base_FOV : float = 75.0
@onready var dash_FOV : float = 90.0

var was_in_air = false  # Stores whether the player was in the air before dashing

#---

#Gravity variables
@export_group("Gravity variables")
@export var gravity_strength : float = 2.0
#---
var last_rotation_angle : float = 0.0

# ----------------

#ATTACK

#Light attack
@export_category("Attacks")
@export_subgroup("Light attack")
var current_damage : float

@export var light_attack_damage : float
@onready var light_damage : float
@onready var charged_damage: float

#---

#Charged  attack
@export_subgroup("Charged attack")
@export var charged_attack_damage : float
@onready var vfx_spawned : bool = false

#Animation combo
@onready var animation_combo_index : int = 1

#---

#Buffer
@onready var combo_window_is_active : bool = false
@onready var light_attack_input_was_pressed : bool = false
@onready var post_attack_windows_duration : float = 1.0
@onready var post_attack_windows_timer : float = 0.0
@onready var is_in_post_attack_phase : bool = false

# ----------------

@export_group("Attack VFX")
var current_vfx : MeshInstance3D

# ----------------

#CAMERA
@export_category("Camera")
@export var shake_fade: float = 10.0

var current_shake: float
@export var light_attack_shake: float = 0.1
@export var charged_attack_shake: float = 0.3
@export var death_shake: float = 0.3
var shake_strength: float = 0.0
var original_position: Vector3  # Stocke la position d'origine

# --------------------------------------------------------------------------

# BASE FUNCTIONS

# --------------------------------------------------------------------------

func _ready():
	_previous_position = global_position
	original_position = camera_position.transform.origin  # Sauvegarde la position de base
	health_bar.init_health(player_max_hp)
	Engine.time_scale = 1.0


func trigger_shake() -> void:
	shake_strength = current_shake


func _process(delta: float) -> void:
	var current_state = base_state_machine.get_current_node()
	charge_attack_movement_mode()
	
	if Input.is_action_pressed("charge_attack"):
		print("Le bouton est pressé")
		
		
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		camera_position.transform.origin = original_position + Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			0
		)
	launch_in_the_air_animation()

func _physics_process(delta: float) -> void:
	add_gravity(delta)
	decrease_dash_countdown(delta)
	update_movement_tracking(delta)
	

	if dash_cooldown_after_stop > 0:
		dash_cooldown_after_stop -= delta


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

# --------------------------------------------------------------------------

# STATES FUNCTIONS

# --------------------------------------------------------------------------

func _on_idle_state_entered() -> void:
	is_idle = true

func _on_idle_state_processing(delta: float) -> void:
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	enable_can_transition()

	activate_in_the_air_state()

	activate_movement_state()
	activate_charged_attack_state()
	activate_light_attack_state()
	activate_dash_state()

func _on_idle_state_exited() -> void:
	is_idle = false
#---

func _on_movement_state_entered() -> void:
	is_moving = true
	

func _on_movement_state_processing(delta: float) -> void:
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	activate_idle_state()
	activate_charged_attack_state()
	activate_light_attack_state()
	activate_dash_state()
	activate_in_the_air_state()

func _on_movement_state_exited() -> void:
	is_moving = false
	
#---
func _on_in_the_air_state_entered() -> void:
	is_in_the_air = true


func _on_in_the_air_state_processing(delta: float) -> void:
	move_the_character()

	#activate_in_the_air_state()
	activate_dash_state()


	if is_on_floor():
		
		activate_idle_state()
		activate_movement_state()


func _on_in_the_air_state_exited() -> void:
	is_in_the_air = false


#---

func _on_dash_state_entered() -> void:
	is_dashing = true
	can_transition = false
	disable_can_transition()
	initiate_dash()
	start_dash()
	launch_dash_animation()

func _on_dash_state_physics_processing(_delta: float) -> void:
	execute_dash() #Launch the dash if all conditions are met

func _on_dash_state_exited() -> void:
	assign_movement_blend_position()
	is_dashing = false
	can_transition = true

#---

#When we are in light attack mode, first we disable the other states consequences
#mainly charged_attack mesh and bools. Then we declare that we are in a light attack
func _on_light_attack_state_entered() -> void:

	is_recovering = false
	is_charged_attacking = false
	enable_movement()
	disable_can_transition()
	disable_charge_attack_lock_mesh()
	disable_charge_attack_mode()
	is_light_attacking


#During the light attack  we allow the character to move normaly and if et pressed the input
#we save this information in a bool
func _on_light_attack_state_processing(delta: float) -> void:
	assign_movement_blend_position()  #Create a blend between idle walk and run
	move_the_character()
	
	if Input.is_action_just_pressed("light_attack"):
		light_attack_input_was_pressed = true
	

func _on_light_attack_state_exited() -> void:

	can_transition = true
	is_light_attacking = false


func _on_light_attack_system_area_3d_area_entered(area: Area3D) -> void:
	make_damage(area , light_attack_damage)

#---

func _on_charged_attack_state_entered() -> void:
	is_charged_attacking = true
	disable_can_transition()
	move_the_character()

	await get_tree().create_timer(2.0).timeout
	
	send_event_state_chart("IsFinishingTheChargedAttack")


func _on_charged_attack_state_processing(delta: float) -> void:
	move_the_character()
	assign_movement_blend_position()
	
	if not Input.is_action_pressed("charge_attack"): 
		print("Je devrais arreter l'anime la ")
		enable_can_transition()
		disable_charge_attack_lock_mesh()
		disable_charge_attack_mode()
		is_charged_attacking = false
		activate_idle_state()
		activate_movement_state()
		

#func _on_charged_attack_state_exited() -> void:
	#pass


func _on_charged_attack_system_area_3d_area_entered(area: Area3D) -> void:
	make_damage(area, charged_attack_damage)

#---

func _on_charged_recovery_state_entered() -> void:
	is_recovering = true
	enable_can_transition()


func _on_charged_recovery_state_processing(delta: float) -> void:
	is_charged_attacking = false
	enable_movement()
	can_transition = true
	disable_charge_attack_lock_mesh()
	disable_charge_attack_mode()
	activate_idle_state()
	activate_movement_state()

#---

func _on_charged_recovery_state_exited() -> void:
	
	is_recovering = false
	is_charged_attacking = false
	enable_movement()
	can_transition = true
	disable_charge_attack_lock_mesh()
	disable_charge_attack_mode()
	

#---

func _on_death_state_entered() -> void:
	death()



# --------------------------------------------------------------------------

# STATES ACTIVATIONS FUNCTIONS

# --------------------------------------------------------------------------

func send_event_state_chart(event_name : String)-> void :
	state_chart.send_event(event_name)

#---

func enable_can_transition() -> void :
	can_transition = true

#---

func disable_can_transition() -> void :
	can_transition = false

#---

#If player don't move (inputs and real movement), is on floor, is not in charged attack and he is allowed to transition
#launch idle state
func activate_idle_state()-> void :
	if _input_strength < 0.1 or _real_speed < 0.05 and is_on_floor() and !is_charged_attacking and can_transition:
		base_state_machine.travel("MovementBlendSpace")
		send_event_state_chart("IsIdle")

#---

#If player is moving (inputs and real movement), is on floor, is not dashing and is allowed to transition
#launch movement state
func activate_movement_state()-> void :
	if _input_strength >= 0.1 or _real_speed >= 0.05 and is_on_floor() and !is_dashing and can_transition:
		base_state_machine.travel("MovementBlendSpace")
		send_event_state_chart("IsMoving")

#---

#If player is not on floor, is not dashing and is allowed to transition
#launch in the air state
func activate_in_the_air_state() -> void :

	if not is_on_floor() or Input.is_action_just_pressed("jump") and can_transition:
		send_event_state_chart("IsInTheAir")

#---

#If the player presses the dash action and a state transition is allowed
#launch the dash state
func activate_dash_state() -> void :
	if Input.is_action_just_pressed("dash") and can_transition:
		send_event_state_chart("IsDashing")

#---

func is_in_the_air_state() -> void :
	base_state_machine.travel("Jump")

#---

#If player pressed the input light attack, is on ground and can transition
#launch light attack state
func activate_light_attack_state() -> void :

	if Input.is_action_just_pressed("light_attack") and is_on_floor() and can_transition :
		send_event_state_chart("IsLightAttacking")
		launch_light_attack()
		is_in_post_attack_phase = false
		combo_window_is_active = false
		light_attack_input_was_pressed = false


#---

#If charged attack input was pressed , is on ground is not dashing, charged attacking already and can transition
#launch charged attack state
func activate_charged_attack_state() -> void  :
	if Input.is_action_pressed("charge_attack") and is_on_floor() and !is_dashing and !is_charged_attacking and can_transition:
		send_event_state_chart("IsChargedAttacking")
		#base_state_machine.stop()
		base_state_machine.travel("ChargedAttackBlendTree")
		



# --------------------------------------------------------------------------

## HEALTH

func take_damage(damage : float) -> void :
	if not after_hit_invicibility :
		player_current_hp -= damage
		check_if_dead()
		launch_hit_logic()
		health_bar.health = player_current_hp

#---


#---

func launch_hit_logic() -> void :
	if player_current_hp <= 0 :
		return

	base_state_machine.travel("Hit")	#Animation
	player_is_blinking()				#Blink

#---

func check_if_dead() -> void :
	if player_current_hp <= 0 :
		send_event_state_chart("IsDead")

#---

func death() -> void :

	base_state_machine.travel("Death")
	is_alive = false
	can_move = false
	camera_behavior_script.current_camera_offset = camera_behavior_script.death_camera_offset

	await get_tree().create_timer(1.5).timeout

	death_pannel.visible = true
	death_pannel_first_button.grab_focus()

	#await get_tree().create_timer(0.5).timeout
	Engine.time_scale = 0.0

#---

func player_is_blinking():
	if  after_hit_invicibility:
		return # Exit if blinking is already in progress

	after_hit_invicibility = true # Lock blinking

	for i in range(invicibility_duration):
		player_mesh.visible = not player_mesh.visible
		await get_tree().create_timer(blink_interval).timeout

	# Restore visibility and re-enable blinking
	player_mesh.visible = true
	after_hit_invicibility = false

# ----------------

# --------------------------------------------------------------------------

## MOVEMENT

func add_gravity(delta : float) -> void :
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_strength

#---

func move_the_character() -> void:
	if can_move :# and not charge_attack_mode:
		# Get inputs controle
		direction_vector_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var player_movement_direction: Vector3 = Vector3(direction_vector_input.x, 0, direction_vector_input.y).normalized()
		var input_strength: float = direction_vector_input.length()

		# Apply horizontal movement
		if direction_vector_input.length() > 0.2:
			velocity.x = player_movement_direction.x * player_current_speed * input_strength
			velocity.z = player_movement_direction.z * player_current_speed * input_strength

			# Rotation of the character
			var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
			if  not charge_attack_mode:
				rotation.y = player_rotation_angle
		else:
			velocity.x = 0
			velocity.z = 0

		# Jump logic (Y axis)
		if Input.is_action_just_pressed("jump") and is_on_floor() and  not charge_attack_mode:
			jump_the_character()

	# Apply movement
	move_and_slide()

#---

func charge_attack_movement_mode() -> void :

	if is_charged_attacking:
		#Slow down the player during the charged attack mode
		player_current_speed = player_charged_attack_speed
		
		#Use the right joystick input in order to calculate a directional vector
		direction_vector_input= Input.get_vector("aim_left", "aim_right", "aim_forward", "aim_backward")
		#Get the 2D vector from the right joystick, transform it into a Vector3 on the axis X and Z and normalized it to get a constant vector
		var player_movement_direction: Vector3 = Vector3(direction_vector_input.x, 0, direction_vector_input.y).normalized()
		#Use the input length to get the magnetude
		var input_strength: float = direction_vector_input.length() #Input magnetude (from 0 to 1)

		## Rotation of the character in the direction of the movement
		 # Mise à jour de la rotation uniquement si il y a une entrée significative
		if input_strength > 0.001:  # If there is a movement of the joystick
			#Calculate the player rotation angle with the function atan2
			var player_rotation_angle: float = atan2(player_movement_direction.x, player_movement_direction.z)
			#Assign the rotation to the player
			rotation.y = player_rotation_angle
			#Save the rotation
			last_rotation_angle = player_rotation_angle
		else: #If the player drop the joystick
			# Let the player in the last rotation angle to not reset his orientation if he drop his joystick
			rotation.y = last_rotation_angle
	else : 
		player_current_speed = player_normal_speed

# --------------------------------------------------------------------------

## JUMP

func jump_the_character() -> void :
	velocity.y = jump_strength

# --------------------------------------------------------------------------

## IN THE AIR
func launch_in_the_air_animation() -> void :
	if not is_on_floor() and is_in_the_air:

		base_state_machine.travel("Jump")
		aura_mesh.visible = false


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
	animation_tree.set("parameters/MiraAnimations/ChargedAttackBlendTree/MovementBlendSpace/blend_position",velocity.length())



#---
# Updates input, speed, and idle timer to track player movement state.

func update_movement_tracking(delta: float) -> void:
	# Player input
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_backward", 0.2)
	_input_strength = input_vector.length()

	# Real speed
	var displacement = global_position - _previous_position
	_real_speed = displacement.length() / delta
	_previous_position = global_position

	## Timer Idle
	#if _input_strength == 0 and _real_speed < 0.05:
		#_idle_timer += delta
	#else:
		#_idle_timer = 0.0

#---

func enable_movement() -> void :
	can_move = true

#---

func disable_movement() -> void :
	can_move = false

# --------------------------------------------------------------------------

## DASH

func initiate_dash() -> void :

	
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
	enable_can_transition()
	activate_movement_state()
	activate_idle_state()
	activate_in_the_air_state()
	

#---

func modify_fov_with_tween() -> void :
	if Input.is_action_just_pressed("dash"):
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

	light_attack_input_was_pressed = false
	combo_window_is_active = false
	var target_state = "Combo" + str(animation_combo_index) + "BlendTree"
	base_state_machine.stop()
	await get_tree().process_frame
	base_state_machine.travel(target_state)
	
	if animation_combo_index == 1 :
		await get_tree().create_timer(light_attack_combo_1_duration).timeout #Duration of the animation : 0.5. Timescale : 1.75 so : 0.5/1.75 = 0,288s
		activate_idle_state()
		activate_movement_state()
	elif animation_combo_index == 2 :
		await get_tree().create_timer(light_attack_combo_2_duration).timeout #Duration of the animation : 0.2917. Timescale : 1.75 so : 0.2917/1.75 = 0,167s
		activate_idle_state()
		activate_movement_state()
	elif animation_combo_index == 3 :
		await get_tree().create_timer(light_attack_combo_3_duration / 2).timeout
		set_animation_index_values(1)
		await get_tree().create_timer(light_attack_combo_3_duration / 2).timeout #Duration of the animation : 2.125. Timescale : 1.75 so : 2.125/1.75 = 1.214s
		activate_idle_state()
		activate_movement_state()


#---

func set_animation_index_values(index_values : int) -> void:
	animation_combo_index = index_values

#---

func reset_animation_index():
	animation_combo_index = 1

#---

func toggle_combo_windows(status : bool) -> void :
	combo_window_is_active = status

#---

func activate_combo_if_clicked_during_combo_window() -> void :
	if light_attack_input_was_pressed and combo_window_is_active :
		launch_light_attack()
	else:
		launch_countdown_for_combo_windows()

#---

func launch_countdown_for_combo_windows() -> void :
	post_attack_windows_timer = post_attack_windows_duration

#---

func player_attack_1_sfx() -> void :
	attack_1_sound.play()

#---

func player_attack_2_sfx() -> void :
	attack_2_sound.play()

#---

func player_attack_3_sfx() -> void :
	attack_3_sound.play()

#---
func instantiate_combo_1_vfx() -> void :
	var combo_1_vfx_instance = combo_1_vfx_scene.instantiate()
	current_vfx = combo_1_vfx_instance
	light_attack_vfx_storage.add_child(combo_1_vfx_instance)

	# 1. Positionne le VFX à l'emplacement de spawn
	combo_1_vfx_instance.global_transform = base_combo_position.global_transform

	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = combo_1_vfx_instance.global_transform.origin

	# 3. Applique le scale en gardant la même position
	combo_1_vfx_instance.global_transform = Transform3D(
		Basis(combo_1_vfx_instance.global_transform.basis.scaled(Vector3(1.5, 1, 1.5))),
		current_position
	)

func destroy_light_attack_vfx() -> void :
	await get_tree().create_timer(0.5).timeout
	current_vfx.queue_free()


func instantiate_combo_2_vfx() -> void :

	var combo_2_vfx_instance = combo_2_vfx_scene.instantiate()
	current_vfx = combo_2_vfx_instance
	light_attack_vfx_storage.add_child(combo_2_vfx_instance)

	# 1. Positionne le VFX à l'emplacement de spawn
	combo_2_vfx_instance.global_transform = base_combo_position.global_transform

	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = combo_2_vfx_instance.global_transform.origin

	# 3. Applique le scale en gardant la même position
	combo_2_vfx_instance.global_transform = Transform3D(
		Basis(combo_2_vfx_instance.global_transform.basis.scaled(Vector3(1.5, 1, 1.5))),
		current_position
	)

#---

func enable_combo_3_vfx() -> void :
	combo_3_vfx.visible = true


#---

func disable_combo_3_vfx() -> void :
	combo_3_vfx.visible = false

#---

func launch_combo_3_vfx_animation() -> void :
	combo_3_animation_player.play("Attack_Charge")

#---

func make_damage(area : Area3D, damage : float) -> void :
	# Récupérer le nœud parent de l'Area
	var parent = area.get_parent()
	if parent.has_method("take_damage") and parent.is_in_group("enemy"):
		parent.take_damage(damage)
		trigger_shake()
		return

func enable_light_attack_area() -> void :
	light_attack_area.monitoring = true

func disable_light_attack_area() -> void :
	light_attack_area.monitoring = false

func enable_long_range_collision() -> void :
	long_range_collision_shape.disabled = false

func disable_long_range_collision() -> void :
	long_range_collision_shape.disabled = true

func enable_short_range_collision() -> void :
	short_range_collision_shape.disabled = false

func disable_short_range_collision() -> void :
	short_range_collision_shape.disabled = true

func enable_charged_attack_area() -> void :
	charged_attack_area.monitoring = true

func disable_charged_attack_area() -> void :
	charged_attack_area.monitoring = false

func enable_charged_attack_collision() -> void :
	charged_attack_collision.disabled = false
	charged_attack_impact_collision.disabled = false

func disable_charged_attack_collision() -> void :
	charged_attack_collision.disabled = true
	charged_attack_impact_collision.disabled = true

func set_light_attack_camera_shake_value() -> void :
	current_shake = light_attack_shake

func set_charged_attack_camera_shake_value() -> void :
	current_shake = charged_attack_shake

func charged_attack_sfx() -> void :
	charged_attack_sound.play()

func enable_charge_attack_charging_vfx() -> void :
	charge_attack_charging.visible = true

func disable_charge_attack_charging_vfx() -> void :
	charge_attack_charging.visible = false

func enable_charge_attack_mode() -> void :
	charge_attack_mode = true

func disable_charge_attack_mode() -> void :
	charge_attack_mode = false

func enable_charge_attack_lock_mesh() -> void :
	charge_attack_lock_mesh.visible = true

func disable_charge_attack_lock_mesh() -> void :
	charge_attack_lock_mesh.visible = false

func instantiate_charged_attack_impact_vfx() -> void :
	if vfx_spawned:
		return

	vfx_spawned = true
	var charged_attack_impact_vfx_instance = charged_attack_impact_vfx.instantiate()

	charged_attack_impact_vfx_storage.add_child(charged_attack_impact_vfx_instance)

	# 1. Positionne le VFX à l'emplacement de spawn
	charged_attack_impact_vfx_instance.global_transform = charged_attack_impact_vfx_spawn_position.global_transform

	# 2. Sauvegarde la position actuelle (après le spawn)
	var current_position = charged_attack_impact_vfx_instance.global_transform.origin

		# 3. Applique le scale et la rotation en gardant la même position
	var new_basis = charged_attack_impact_vfx_instance.global_transform.basis
	#new_basis = new_basis.rotated(Vector3(0, 0, 1), -PI)  # Rotation de -180° sur l'axe Z
	new_basis = new_basis.scaled(Vector3(2.5, 1, 2.5))
	charged_attack_impact_vfx_instance.global_transform = Transform3D(new_basis, current_position)
	vfx_spawned = false

# --------------------------------------------------------------------------

## VFX
func instantiate_foot_step_vfx() -> void :
	var vfx_instance = foot_step_vfx.instantiate()  # Crée une instance du VFX
	movement_vfx_storage.add_child(vfx_instance)  # Ajoute le VFX dans la scène (même parent que le joueur)
	vfx_instance.global_transform = global_transform  # Place le VFX exactement où est le joueur
	play_random_footstep()

#---

func freeze_frame() -> void :
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.03).timeout
	Engine.time_scale = 1.0

# --------------------------------------------------------------------------

## SFX
func play_random_footstep() -> void:
	if footstep_sounds.is_empty():
		return

	var random_index = randi() % footstep_sounds.size()  # Choisir un son aléatoire
	mira_step.stream = footstep_sounds[random_index]
	mira_step.pitch_scale = randf_range(0.9, 1.1)  # Légère variation du pitch pour plus de naturel
	mira_step.play()
