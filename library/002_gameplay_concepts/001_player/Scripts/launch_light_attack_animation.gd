extends Node

@export var animation_index_script : FightAnimationIndex
@onready var animation_index_number  = animation_index_script.animation_index

@export var animation_tree : AnimationTree

@onready var fight_state_machine = animation_tree["parameters/MiraAnimation/FightStateMachine/LightAttackStateMachine/playback"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fight_state_machine.travel("FightStateMachine")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		animation_index_number  = animation_index_script.animation_index
		animation_index_script .increment_index_animation()
		animation_index_script.clamp_animation_index()
		launch_light_attack_animation()


func launch_light_attack_animation() -> void : 

	fight_state_machine.travel("Combo_" + str(animation_index_number))
	print("Combo_" + str(animation_index_number))
