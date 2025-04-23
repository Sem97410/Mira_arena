extends Node

@export var animation_player : AnimationPlayer
@export var main_menu_pannel : Control
@export var pre_menu_pannel : VBoxContainer
@export var first_main_button : Button # = $Main_buttons_margin_container/HBoxContainer/Main_buttons_V_container/Story_mode
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
	pre_menu_pannel.visible = true
	is_in_main_menu = false

func activate_main_menu() -> void : 
	main_menu_pannel.visible = true
	is_in_main_menu = true
	first_main_button.grab_focus()
	
	
func hide_pre_menu() -> void : 
	pre_menu_pannel.visible = false

func hide_main_menu() -> void : 
	main_menu_pannel.visible = false

func launch_transition_animation() -> void : 
	if Input.is_action_just_pressed("launch_main_menu") and is_in_main_menu == false:
		is_in_main_menu = true
		pre_menu_pannel.visible = false
		animation_player.play("Transition")
		
