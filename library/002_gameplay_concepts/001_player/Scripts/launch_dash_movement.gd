extends Node

#----------------------------------
## REFERENCES
#Nodes
@export var player: CharacterBody3D  

# -----------------
#Values
@export var dash_duration: float = 0.2 #In second
@export var dash_length : float
@onready var start_time : int = 0 #When the dash start

# -----------------
#Localisation
var start_position : Vector3 #Begining of the dash
var destination_target : Vector3 #End of the dash

#----------------------------------

func _process(delta):
	if Input.is_action_just_pressed("dash"):
		start_dash()	#Configure the information of the dash

func _physics_process(delta):
	
	execute_dash() #Launch the dash if all conditions are met

#----------------------------------
#Dash initialisation
func start_dash():
	start_position = player.position #Stock the player position
	start_time = Time.get_ticks_msec() #Save the exact moment when the dash started
	destination_target = player.position + player.transform.basis.z * dash_length #Set up the destination target
	#Destination target = A position in front of the player 

#----------------------------------
	
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
