extends Node

@export var charged_attack_sound : AudioStreamPlayer

@export var charge_attack_broom_dash_vfx : Node3D
@export var charge_attack_charging : Node3D
@export var charge_attack_impact : Node3D
@export var charge_attack_impact_animation_player : AnimationPlayer




func charged_attack_sfx() -> void : 
	charged_attack_sound.play()

func enable_charge_attack_charging_vfx() -> void : 
	charge_attack_charging. visible = true

func disable_charge_attack_charging_vfx() -> void : 
	charge_attack_charging. visible = false
