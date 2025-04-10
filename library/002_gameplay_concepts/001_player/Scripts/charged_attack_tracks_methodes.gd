extends Node

@export var charged_attack_sound : AudioStreamPlayer

@export var charge_attack_charging : Node3D


@export var charge_attack_lock_mesh : Node3D
@export var movement_script : PlayerMovementScript


func charged_attack_sfx() -> void : 
	charged_attack_sound.play()

func enable_charge_attack_charging_vfx() -> void : 
	charge_attack_charging. visible = true

func disable_charge_attack_charging_vfx() -> void : 
	charge_attack_charging. visible = false


func enable_charge_attack_mode() -> void : 
	#print("Test")
	movement_script.can_move = false
	movement_script.charge_attack_mode = true
	
func disable_charge_attack_mode() -> void : 
	movement_script.can_move = true
	movement_script.charge_attack_mode = false

func enable_charge_attack_lock_mesh() -> void : 
	charge_attack_lock_mesh.visible = true

func disable_charge_attack_lock_mesh() -> void : 
	charge_attack_lock_mesh.visible = false
