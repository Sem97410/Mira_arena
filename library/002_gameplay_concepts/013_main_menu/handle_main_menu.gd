extends Node

@export var animation_player : AnimationPlayer
@export var main_menu_panel : Control
@export var pre_menu_panel : VBoxContainer
@export var first_main_button : Button 
@export var main_menu_clock_background : TextureRect

@onready var is_in_main_menu : bool = false

func _ready() -> void:
	get_tree().paused = false
	animation_player.play("StartAnimation")





func _process(delta: float) -> void:
	launch_transition_animation()

func go_to_menu() -> void : 
	
	if Input.is_action_just_pressed("launch_main_menu") :	
		animation_player.play("Transition")
	

func activate_pre_menu() -> void : 
	pre_menu_panel.visible = true
	is_in_main_menu = false

func activate_main_menu() -> void : 
	main_menu_panel.visible = true
	#main_menu_clock_background.visible = true
	is_in_main_menu = true



	first_main_button.grab_focus()
	
	
func hide_pre_menu() -> void : 
	pre_menu_panel.visible = false

func hide_main_menu() -> void : 
	main_menu_panel.visible = false
	main_menu_clock_background.visible = false

func launch_transition_animation() -> void : 
	if Input.is_action_just_pressed("launch_main_menu") and is_in_main_menu == false:
		is_in_main_menu = true
		pre_menu_panel.visible = false
		animation_player.play("Transition")
		
