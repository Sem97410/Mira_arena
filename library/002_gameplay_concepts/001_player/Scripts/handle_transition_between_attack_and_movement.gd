extends Node

@export_multiline var Summary : String
@export var index_animation_script : FightAnimationIndex
@export var animation_tree : AnimationTree



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	handle_transition_between_fight_and_movement()

func handle_transition_between_fight_and_movement() -> void : 
	if index_animation_script.current_reset_countdown > 0 :
		animation_tree.set("parameters/MiraAnimations/conditions/can_transition", false)

	else :
		animation_tree.set("parameters/MiraAnimations/conditions/can_transition", true)

	
	
