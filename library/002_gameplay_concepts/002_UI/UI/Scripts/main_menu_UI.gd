extends Control
#------------------------------
#REFERENCES
#------------------------------
#MAIN BUTTONS
@export var main_button_general_container : MarginContainer  #= $Main_buttons_margin_container
@export var first_main_button : Button # = $Main_buttons_margin_container/HBoxContainer/Main_buttons_V_container/Story_mode
#-----------------
#Quit
@export var quit_game_confirmation_pannel : PanelContainer # $Quit_game_confirmation_pannel
@export var quit_game_confirmation_pannel_first_button : Button # $Quit_game_confirmation_pannel/VBoxContainer/HBoxContainer/Stay_in_game_confirmation_button
#-----------------

#INFORMATIONS
@export var not_ready_pannel : PanelContainer #= $Not_ready_pannel
@export var close_not_ready_pannel_button : Button # $Not_ready_pannel/MarginContainer/VBoxContainer/Close_not_ready_pannel_button
#-----------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	first_main_button.grab_focus()
	get_tree().paused = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#------------------------------
#MAIN BUTTON
#-----------------
#ARENA MODE

func _on_arena_mode_button_down() -> void:
	get_tree().change_scene_to_file("res://general/Sprint_06_12/Scenes/blocking_level_design.tscn") 
#-----------------

#QUIT GAME
func _on_quit_game_button_down() -> void:
	main_button_general_container.visible = false
	quit_game_confirmation_pannel.visible = true
	quit_game_confirmation_pannel_first_button.grab_focus()

func _on_quit_game_confirmation_button_button_down() -> void:
	get_tree().quit()

func _on_stay_in_game_confirmation_button_button_down() -> void:
	quit_game_confirmation_pannel.visible = false
	main_button_general_container.visible = true
	first_main_button.grab_focus()
		
#-----------------
#NOT READY BUTTONS

func _on_story_mode_button_down() -> void:
	not_ready_pannel.visible = true
	await get_tree().create_timer(1.5).timeout
	not_ready_pannel.visible = false

func _on_settings_button_down() -> void:
	not_ready_pannel.visible = true
	await get_tree().create_timer(1.5).timeout
	not_ready_pannel.visible = false
