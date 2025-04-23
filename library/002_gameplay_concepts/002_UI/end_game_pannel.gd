extends Node3D
@export var end_game_panel : Control

@export var first_button : Button 

@export var pause_panel : Control
@export var death_panel : Control
@export var health_bar : ProgressBar

func _process(delta: float) -> void:
	launch_end_game_pannel()

func launch_end_game_pannel() -> void : 
	
	if Input.is_action_just_pressed("end_game_button_pannel"):
		Engine.time_scale = 0
		pause_panel.visible = false
		death_panel.visible = false
		health_bar.visible = false
		end_game_panel.visible = true
		first_button.grab_focus()


func _on_main_menu_button_button_down() -> void:
	get_tree().change_scene_to_file("res://library/002_gameplay_concepts/002_UI/title_screen/title_screen.tscn")
