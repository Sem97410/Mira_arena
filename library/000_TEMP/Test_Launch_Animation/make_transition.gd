extends Node

@export var animation_tree : AnimationTree

@onready var base_state_machine : AnimationNodeStateMachinePlayback  = animation_tree["parameters/MiraAnimation/playback"]
@onready var fight_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimation/FightStateMachine/playback"]
@onready var movement_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimation/MovementStateMachine/playback"]
@onready var light_attack_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimation/FightStateMachine/LightAttackStateMachine/playback"]
@onready var charge_attack_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimation/FightStateMachine/ChargeAttackStateMachine/playback"]

@onready var animation_index : int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	handle_fight_state()
	launch_light_attack()
	launch_movement()
	print("Animation index is : ", animation_index)
	
	print(base_state_machine.get_current_node())

func launch_light_attack() -> void : 
	
	if Input.is_action_just_pressed("attack"):

		fight_state_machine.travel("LightAttackStateMachine")
		manage_animation_index()
		light_attack_state_machine.travel("Combo_" + str(animation_index))
		
		
func manage_animation_index() -> void : 
	
	animation_index += 1
	
	if animation_index > 3 :
		animation_index = 1


func launch_movement() -> void : 
	if Input.is_action_just_pressed("Right_Click") : 
		
		base_state_machine.travel("MovementStateMachine")

func launch_charge_attack() -> void : 
	animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanChargeAttack", true)
	base_state_machine.travel("FightStateMachine")
	fight_state_machine.travel("ChargeAttackStateMachine")
	charge_attack_state_machine.travel("fly")
	
	
func handle_fight_state() -> void : 
	
	if Input.is_action_just_pressed("attack"): 
		animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", true)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanLightAttack", true)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanChargeAttack", false)
		
	elif Input.is_action_just_pressed("Charge_attack"):
		animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", true)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanChargeAttack", true)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanLightAttack", false)
		reset_animation_index()
		
	elif Input.is_action_just_pressed("Right_Click"):
		animation_tree.set("parameters/MiraAnimation/conditions/IsFighting", false)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanLightAttack", false)
		animation_tree.set("parameters/MiraAnimation/FightStateMachine/conditions/CanChargeAttack", false)
		reset_animation_index()
		
		
func reset_animation_index() -> void : 
	animation_index = 0
