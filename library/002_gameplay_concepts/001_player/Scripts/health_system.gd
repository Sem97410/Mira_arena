extends Node
class_name HealthSystem

@export var player_max_hp : float = 100
@onready var player_current_hp : float = player_max_hp
@export var animation_tree : AnimationTree
@export var animation_player : AnimationPlayer
@onready var base_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/playback"]
#@onready var death_state_machine : AnimationNodeStateMachinePlayback = animation_tree["parameters/MiraAnimations/DeathStateMachine/playback"]

@export var player : CharacterBody3D
@export var player_mesh : Node3D
#@export var camera_shake_logic : CameraShake

@onready var blink_interval : float = 0.2
@onready var after_hit_invicibility : bool = false
@export var invicibility_duration : float = 5.0 #base on the number of blink

@export var movement_script : PlayerMovementScript
@onready var is_alive : bool = true
@export var test_button : Button

func _ready() -> void:
	animation_tree.active = true

	
#func _process(_delta: float) -> void:
	#print("Player current HP : ", player_current_hp)
	#var current_state = animation_tree.get("parameters/state/current")

	##print("Je suis dans le state : ", current_state)
	#if Input.is_action_just_pressed("debug_input"):
		#take_damage(50.0)
		
		
		
func take_damage(damage : float) -> void :
	if not after_hit_invicibility :
		player_current_hp -= damage
		check_if_dead()
		launch_hit_logic()
		


func launch_hit_logic() -> void :
	if player_current_hp <= 0 :
		return
		
	#print("Hit logic")
	base_state_machine.travel("Hit")	#Animation
	player_is_blinking()				#Blink

	
	

func check_if_dead() -> void :
	if player_current_hp <= 0 :
		#print("Player is dead")
		death()
		

func death() -> void :
	#print("Block movement")
	#print("Death logics")
	
	base_state_machine.travel("Death")
	is_alive = false
	#for action in InputMap.get_actions():
		#InputMap.action_erase_events(action)
	
	test_button.grab_focus()
	movement_script.can_move = false
	
	#await get_tree().create_timer(0.1).timeout
	
	#animation_tree.active = false
	#animation_player.play("Death")
	
	
	
	
func player_is_blinking():
	if  after_hit_invicibility:
		return # Exit if blinking is already in progress

	after_hit_invicibility = true # Lock blinking
	
	 #int(player.i_frame_duration / blink_interval)
	
	for i in range(invicibility_duration):
		player_mesh.visible = not player_mesh.visible
		await get_tree().create_timer(blink_interval).timeout
	
	# Restore visibility and re-enable blinking
	player_mesh.visible = true
	after_hit_invicibility = false


func _on_test_button_pressed() -> void:
	print("Button was pressed")

	get_tree().reload_current_scene()
