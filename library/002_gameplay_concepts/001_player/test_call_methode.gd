extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func launch_call_methode( temp : int) -> void : 
	#print("Was launch in animation", temp)
	#do_action_1()
	#do_action_2()

func do_action_1() -> void : 
	print("Action A")
	print("Block input A")
	
func do_action_2() -> void : 
	print("Action B")
	print("Block input B")

func do_action_3() -> void : 
	print("Action C")
	print("Block input C")
	
func end_action(temp : String) -> void : 
	print("Get input back ", temp)
