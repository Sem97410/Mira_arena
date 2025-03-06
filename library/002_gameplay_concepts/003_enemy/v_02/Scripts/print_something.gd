extends Node
@export var debug_message : String
@export var state_chart : StateChart
@export var idle_message : String

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_input"): 
		#print(debug_message)
		state_chart.send_event("isdead")
	


func _on_walk_state_entered() -> void:
	print("Je marche :o")


func _on_area_3d_area_entered(area: Area3D) -> void:
	state_chart.send_event("isdead")


func _on_idle_state_entered() -> void:
	print("Je suis Idle")
