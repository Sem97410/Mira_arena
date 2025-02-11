extends Node


@export_multiline var SUMMARY : String

#----------------------------------
@export_category("Scene Nodes")
## REFERENCES
#Nodes
@export var player: CharacterBody3D  
@export var camera : Camera3D
@export var animation_tree : AnimationTree

# -----------------
@export_category("General values")
#General value
@export var dash_duration: float = 0.2 #In second
@export var latence_between_dash : float = 3.0

# -----------------
#Dash movement
@export_category("Dash movement")
@export var dash_length : float
@onready var start_time : int = 0 #When the dash start
@onready var dash_countdown : float = 0.0


# -----------------
#Localisation of the player
@export_category("Player localisation")
var start_position : Vector3 #Begining of the dash
var destination_target : Vector3 #End of the dash

# -----------------
#FOV
@export_category("FOV")
@onready var base_FOV : float = 75.0
@onready var dash_FOV : float = 90.0

# -----------------
#Action lines
@export_category("Action lines")
@export var action_line_sprites : AnimatedSprite2D

# -----------------
#Animations
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]

# -----------------
#After images
@export_category("After images")
@export var afterimage_scene: PackedScene  # Utilise MiraAfterImage.tscn
@export var spawn_count: int = 5  
@export var spawn_interval: float = 0.1  
var previous_positions: Array = []  # Stocke les anciennes positions du joueur
#----------------------------------

func _process(delta):
	
	if Input.is_action_just_pressed("dash") && dash_countdown <= 0:
		
		#start_dash()	#Configure the information of the dash
		#modify_fov_with_tween()
		#launch_action_line()
		launch_dash_animation()
		
		#launch_after_images()
		
		dash_countdown = latence_between_dash
		
	decrease_dash_countdown(delta)
		

func _physics_process(delta):

	execute_dash() #Launch the dash if all conditions are met

#----------------------------------
## DASH countdown
func decrease_dash_countdown(delta : float ) -> void : 
	if dash_countdown > 0:
		dash_countdown -= delta


#----------------------------------
## DASH MOVEMENT

# -----------------
#Dash initialisation
func start_dash():
	
	start_position = player.position #Stock the player position
	start_time = Time.get_ticks_msec() #Save the exact moment when the dash started
	destination_target = player.position + player.transform.basis.z * dash_length #Set up the destination target
	#Destination target = A position in front of the player 

# -----------------
#Dash physical movement
func execute_dash():
	
	if start_time > 0 : #Activate the dash only if start_time is superior to 0

		var t : float =  ((float)(Time.get_ticks_msec() - start_time) / 1000.0) / dash_duration
		
		#Time.get_ticks_msec() - start_time 									-> Elapsed time since the start of the dash (in milliseconds)
		#((Time.get_ticks_msec() - start_time) / 1000.0) 						-> convert the result in second (and not milliseconds)
		#(Time.get_ticks_msec() - start_time) / 1000.0) / dash_duration 		-> Normalize in order to be between 0 and 1
		
		#It's a temporal interpolation
		
		var step : Vector3
		
		step = start_position.lerp(destination_target, t) 
		# Physical interpolation between Start position and destination_target base on t
		#You could write it like that : 
		#step = start_position + (destination_target - start_position) * t  ## Same than lerp()
		#When t = 0 , step = start_position
		#When t = 1 , step = destination_target
		step -= player.position
		
		var coll : KinematicCollision3D = player.move_and_collide(step)
		
		#cube.velocity = step / delta
		#cube.move_and_slide()
		if t >= 1 or coll :
			start_time = 0


#----------------------------------
## DASH FOV
func modify_fov_with_tween() -> void : 
	if Input.is_action_just_pressed("dash"):
		#print("Modification of the FOV")
		var tween = create_tween()

		tween.tween_property(camera, "fov", dash_FOV, 0.1)
	
		await get_tree().create_timer(0.3).timeout
		
		var tween_back = get_tree().create_tween()
		tween_back.tween_property(camera, "fov", base_FOV, 0.1)
		

#func modify_fov_while_dashing() -> void : 
	#if Input.is_action_just_pressed("dash"):
		#
		#camera.fov = dash_FOV
		#
		#await get_tree().create_timer(0.5).timeout
		#
		#camera.fov = base_FOV

#----------------------------------
## DASH ACTION LINES

func launch_action_line() -> void : 
	
	action_line_sprites.play("Action lines")
	action_line_sprites.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	action_line_sprites.visible = false
	action_line_sprites.stop()

#----------------------------------
## DASH ANIMATIONS
func launch_dash_animation() -> void : 
	
	base_state_machine.travel("Dash")

#----------------------------------
## DASH AFTER IMAGES

func start_spawning() -> void:
	if player == null:
		print("⚠️ Player non assigné !")
		return
	#print("Start spawning")
	spawn_next_mesh(0)

func spawn_next_mesh(index: int) -> void:
	if index >= spawn_count or previous_positions.size() < spawn_count:
		#print("Probleme de spawn")
		return  
	
	#print("Peut spawn")
	var new_mesh = afterimage_scene.instantiate() as Node3D  # Instancie l'afterimage
	new_mesh.global_transform.origin = previous_positions[index]  # Place à une ancienne position
	player.get_parent().add_child(new_mesh)
	
	await get_tree().create_timer(spawn_interval).timeout  
	spawn_next_mesh(index + 1)
	
func launch_after_images() -> void :
	start_spawning()
	
	# Stocke la position du joueur à chaque frame
	if player:
		previous_positions.append(player.global_transform.origin)

		# Garde seulement les X dernières positions
		if previous_positions.size() > spawn_count:
			previous_positions.pop_front()
