extends Control
#------------------------------
#REFERENCES
#------------------------------
@export var first_button : Button # = $Buttons_container/Reload
@export var game_over_general_container : MarginContainer # = $Buttons_container

@onready var is_pause_panel_activated : bool = false
@onready var is_confirmation_quit_pannel_activated : bool = false

@export var not_ready_label : Label  #= $NotReadyLabel

#------------------------------

#CONFIRMATIONS

#-----------------
#Reload
@export var reload_confirmation_container : PanelContainer #= $ReloadConfirmationPannel
@export var reload_confirmation_first_button : Button #= $ReloadConfirmationPannel/VBoxContainer/ConfirmationButtonContainer/NoButton #$ReloadConfirmationPannel/ConfirmationButtonContainer/VBoxContainer
#-----------------
#Main menu
@export var main_menu_confirmation_container : PanelContainer #= $MainMenuConfirmationPannel
@export var main_menu_confirmation_first_button : Button #= $MainMenuConfirmationPannel/ConfirmationButtonContainer/NoButton
#-----------------
#Quit
@export var quit_confirmations_container : PanelContainer# = $QuitConfirmationPannel
@export var quit_confirmation_first_button : Button #= $QuitConfirmationPannel/ConfirmationButtonContainer/NoButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		self.visible = false
		get_tree().paused = false
		
		#print("Test en début de partie")
		


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("pause_game"):
		#print("Pause game was clicked")
		#toggle_pause_pannel()


#MAIN BUTTON LOGICS


#-----------------
#Retry
func _on_reload_button_down() -> void:
	print("Reload button was pressed")
	game_over_general_container.visible = false
	reload_confirmation_container.visible = true
	reload_confirmation_first_button.grab_focus()
	
#------------------------------
#Reload confirmation pannel
func _on_reload_yes_button_button_down() -> void:
	get_tree().reload_current_scene()

func _on_reload_no_button_button_down() -> void:
	reload_confirmation_container.visible = false
	game_over_general_container.visible = true
	first_button.grab_focus()

#-----------------

#Main Menu
func _on_main_menu_button_down() -> void:
	game_over_general_container.visible = false
	main_menu_confirmation_container.visible = true
	main_menu_confirmation_first_button.grab_focus()
	
#------------------------------
#Main menu confirmation pannel

func _on_main_menu_yes_button_button_down() -> void:
	get_tree().change_scene_to_file("res://library/002_gameplay_concepts/002_UI/title_screen/title_screen.tscn") # Replace with function body.

func _on_main_menu_no_button_button_down() -> void:
	main_menu_confirmation_container.visible = false
	game_over_general_container.visible = true
	first_button.grab_focus()
	
#-----------------

#Settings
func _on_settings_button_down() -> void:
	not_ready_label.visible = true
	print("first part")
	
	await get_tree().create_timer(1.0).timeout
	print("second part")
	not_ready_label.visible = false
	print("Settings button was pressed")
#------------------------------
#Settings pannel
#-----------------

#Quit
func _on_quit_game_button_down() -> void:
	print("Quit game button was pressed")
	game_over_general_container.visible = false
	quit_confirmations_container.visible = true
	quit_confirmation_first_button.grab_focus()
#------------------------------
#Quit game confirmation pannel
func _on_yes_button_button_down() -> void:
	get_tree().quit()

func _on_no_button_button_down() -> void:
	quit_confirmations_container.visible = false
	game_over_general_container.visible = true
	first_button.grab_focus()
