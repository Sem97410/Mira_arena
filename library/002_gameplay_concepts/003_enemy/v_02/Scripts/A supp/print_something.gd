extends Node
@export var debug_message : String
@export var state_chart : StateChart
@export var idle_message : String
@onready var debug_count : int = 0
@onready var debug_count_bool : bool = false
@onready var transition 

func _process(delta: float) -> void:
	if debug_count > 2:
		debug_count_bool = true
		print("La condition est remplie")

	if Input.is_action_just_pressed("debug_input"): 
		debug_count += 1
		print("Debug count is : ",debug_count)

		state_chart.set_expression_property("debug_count", debug_count)

		state_chart.send_event("launch_walk")
	
func _on_walk_state_entered() -> void:
	print("Je suis dans le State Walk")

func _on_area_3d_area_entered(area: Area3D) -> void:
	#state_chart.send_event("isdead")
	pass

func _on_idle_state_entered() -> void:
	print("Je suis dans le state :  Idle")
	
