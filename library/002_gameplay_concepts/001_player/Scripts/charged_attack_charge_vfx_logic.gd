extends Node

@export var animation_player : AnimationPlayer
@export var charged_attack_charge_vfx : Node3D

func eneable_charge_vfx() -> void : 
	charged_attack_charge_vfx.visible = true
	
func disable_charge_vfx() -> void : 
	charged_attack_charge_vfx.visible = false
	
func launch_charged_attack_charge_vfx_animation() -> void : 
	animation_player.play("CHARGE")
