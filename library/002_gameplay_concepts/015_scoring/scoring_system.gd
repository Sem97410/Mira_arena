extends Node

@export var multiplicator_reset_delay : float = 10.0
@onready var time_since_last_hit  : float = 0.0


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	launch_reset_multiplicator_timer(delta)
	
	print("Reset = ", time_since_last_hit)
	
	if Input.is_action_just_pressed("Debug_2"):
		launch_timer()
	

func launch_reset_multiplicator_timer(delta : float) -> void : 
	if time_since_last_hit > 0:
		time_since_last_hit -= delta

func launch_timer() -> void : 
	time_since_last_hit = multiplicator_reset_delay
