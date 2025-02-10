extends Node

class_name Slime

@onready var player_body = Reference.player_pawn
@export var animation_player : AnimationPlayer
@export var nav_agent : NavigationAgent3D
@export var character_body :CharacterBody3D
@export var movement_speed : float
@export var movement_interpolate_strength : float
@onready var rotation_x = character_body.rotation_degrees.x
@onready var rotation_z = character_body.rotation_degrees.z
var attack_cool_down :float = 0.0
var is_attacking = false


enum States{ 
	CHASING,
	PREATTACK,
	ATTACK,
	IDLE
}

var current_state = States.CHASING


func _ready() -> void:
	animation_player.connect("animtion_finished",Callable(self,"_on_animation_player_animation_finished"))

	pass
	
func _physics_process(delta: float) -> void:
	_change_state(current_state,delta)
	pass
	
	
func _change_state(new_state : States, delta : float = 0.0) -> void :
	match new_state :
		States.CHASING :
			print("in chasing states")
			_chasing_state(delta)
		States.PREATTACK :
			print("in preattack state")
			_pre_attack_state()
		States.ATTACK :
			print(" in attack state")
			_attack_state()
		States.IDLE :
			print("in idle state")
			
func _chasing_state(delta) -> void:
	#current_state = States.CHASING
	var current_position = character_body.global_position
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * movement_speed
	character_body.velocity = character_body.velocity.lerp(new_velocity,movement_interpolate_strength * delta)
	rotation_x = 0
	rotation_z = 0
	
	character_body.look_at(player_body.global_position)
	character_body.move_and_slide()
	animation_player.play("Armature|Walk")
	
	var player_position = player_body.global_position
	var enemy_position = character_body.global_position
	var distance_to_player = player_position.distance_to(enemy_position)
	if distance_to_player <= 3 :
		current_state = States.PREATTACK
	else :
		current_state = States.CHASING
		
		
		
	
	
	
	
func _pre_attack_state() -> void :
	animation_player.play("Armature|pre_charge")
	
	
	
		
	pass
	
func _attack_state() -> void:
	if not is_attacking:
		print("in attack state")
		animation_player.play("Armature|charge")
		is_attacking = true
		attack_cool_down =2.0
	if attack_cool_down > 0:
		attack_cool_down -= get_process_delta_time()
	
	else:
		is_attacking = false
		var player_position = player_body.global_position
		var enemy_position = character_body.global_position
		var distance_to_player = player_position.distance_to(enemy_position)
		
		if distance_to_player > 3 :
			current_state = States.CHASING
		else :
			current_state = States.PREATTACK

	
func _update_target_position(target_position):
	nav_agent.set_target_position(target_position)

	
	
	
	
	
		
		
		
		
	


func _on_animation_player_animation_finished (anim_name: StringName) -> void:
	match current_state:
		States.PREATTACK:
			if anim_name == "pre_charge" :
				current_state = States.ATTACK
			
		States.ATTACK : 
			if anim_name == "charge" :
				if attack_cool_down <= 0 :
					var player_position = player_body.global_position
					var enemy_position = character_body.global_position
					var distance_to_player = player_position.distance_to(enemy_position)
					if distance_to_player > 3 :
						print("retour en chasing")
						current_state = States.CHASING
					else :
						current_state = States.ATTACK
					
					
				
				
	
		
			
	pass # Replace with function body.
