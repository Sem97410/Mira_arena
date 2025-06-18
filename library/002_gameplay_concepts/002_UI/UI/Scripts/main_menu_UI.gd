extends Control
#------------------------------
#REFERENCES
#------------------------------
#MAIN BUTTONS
@export var main_button_general_container : MarginContainer  #= $Main_buttons_margin_container
@export var first_main_button : Button # = $Main_buttons_margin_container/HBoxContainer/Main_buttons_V_container/Story_mode

@export var story_focus_indicator_left_text_rect : TextureRect
@export var story_focus_indicator_right_text_rect : TextureRect
@export var story_temp_separation_margin_container_left : MarginContainer
@export var story_temp_separation_margin_container_right : MarginContainer

@export var arena_focus_indicator_left_text_rect : TextureRect
@export var arena_focus_indicator_right_text_rect : TextureRect
@export var arena_temp_separation_margin_container_left : MarginContainer
@export var arena_temp_separation_margin_container_right : MarginContainer

@export var main_quit_focus_indicator_left_text_rect : TextureRect
@export var main_quit_focus_indicator_right_text_rect : TextureRect
@export var main_quit_temp_separation_margin_container_left : MarginContainer
@export var main_quit_temp_separation_margin_container_right : MarginContainer

#------------------------------
#LOGO
@export var logo_container : MarginContainer
#-----------------
#Quit
@export var quit_game_confirmation_pannel : PanelContainer # $Quit_game_confirmation_pannel
@export var quit_game_confirmation_pannel_first_button : Button # $Quit_game_confirmation_pannel/VBoxContainer/HBoxContainer/Stay_in_game_confirmation_button
#-----------------

#INFORMATIONS
@export var not_ready_pannel : PanelContainer #= $Not_ready_pannel
#@export var close_not_ready_pannel_button : Button # $Not_ready_pannel/MarginContainer/VBoxContainer/Close_not_ready_pannel_button
#-----------------
#VIDEO
@export var video_player : VideoStreamPlayer
@export var video_player_container : Control
@export var skip_video_button : Button
@export var video_length : float = 114.0
#-----------------
#MAP SELECTION
@export var map_selection_container : MarginContainer
@export var map_selection_main_button : Button
@export var map_1_information : MarginContainer
@export var map_2_information : MarginContainer 

@export var slimaggedon_max_score_value_label : Label
@export var slimaggedon_last_game_score_value_label : Label
@export var flugdrasil_max_score_value_label : Label
@export var flugdrasil_last_game_score_value_label : Label

@export var slimaggedon_focus_indicator_left_text_rect : TextureRect
@export var slimaggedon_focus_indicator_right_text_rect : TextureRect
@export var slimaggedon_temp_separation_margin_container_left : MarginContainer
@export var slimaggedon_temp_separation_margin_container_right : MarginContainer
@export var flugdrasil_focus_indicator_left_text_rect : TextureRect
@export var flugdrasil_focus_indicator_right_text_rect : TextureRect
@export var flugdrasil_temp_separation_margin_container_left : MarginContainer
@export var flugdrasil_temp_separation_margin_container_right : MarginContainer

@export var quit_focus_indicator_left_text_rect : TextureRect
@export var quit_focus_indicator_right_text_rect : TextureRect
@export var  quit_temp_separation_margin_container_left : MarginContainer
@export var  quit_temp_separation_margin_container_right : MarginContainer



#-----------------
#MUSICS
@export var main_menu_music : AudioStreamPlayer



 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#first_main_button.grab_focus()
	get_tree().paused = false
	Engine.time_scale = 1
	main_menu_music.play()
	print("I'm in main menu")
	set_up_arena_scores()

	
	


#------------------------------
#MAIN BUTTON
#-----------------
#ARENA MODE

func _on_arena_mode_button_down() -> void:
	#get_tree().change_scene_to_file("res://main_scene.tscn") 
	main_button_general_container.visible = false
	logo_container.visible = false
	map_selection_container.visible = true
	map_selection_main_button.grab_focus()
	
#-----------------

#QUIT GAME
func _on_quit_game_button_down() -> void:
	main_button_general_container.visible = false
	quit_game_confirmation_pannel.visible = true
	logo_container.visible = false
	quit_game_confirmation_pannel_first_button.grab_focus()

func _on_quit_game_confirmation_button_button_down() -> void:
	get_tree().quit()

func _on_stay_in_game_confirmation_button_button_down() -> void:
	quit_game_confirmation_pannel.visible = false
	main_button_general_container.visible = true
	logo_container.visible = true
	first_main_button.grab_focus()
		
#-----------------
#NOT READY BUTTONS

func _on_story_mode_button_down() -> void:
	#not_ready_pannel.visible = true
	#await get_tree().create_timer(1.5).timeout
	#not_ready_pannel.visible = false
	
	self.visible = false
	main_menu_music.stream_paused = true
	video_player_container.visible = true
	video_player.play()
	skip_video_button.grab_focus()
	await get_tree().create_timer(video_length).timeout
	stop_video_player()
	#main_menu_sounds.play()
	

func _on_settings_button_down() -> void:
	not_ready_pannel.visible = true
	await get_tree().create_timer(1.5).timeout
	not_ready_pannel.visible = false


func _on_skip_video_button_button_down() -> void:
	stop_video_player()
	
func stop_video_player() -> void : 
	video_player.stop()
	main_menu_music.stream_paused = false
	video_player_container.visible = false
	self.visible = true
	first_main_button.grab_focus()


func _on_practice_mode_button_down() -> void:
	get_tree().change_scene_to_file("res://practice_scene.tscn") 


func _on_slimageddon_button_focus_entered() -> void:
	map_1_information.visible = true
	slimaggedon_temp_separation_margin_container_left.visible = false
	slimaggedon_focus_indicator_left_text_rect.visible = true
	slimaggedon_temp_separation_margin_container_right.visible = false
	slimaggedon_focus_indicator_right_text_rect.visible = true

func _on_slimageddon_button_focus_exited() -> void:
	map_1_information.visible = false
	slimaggedon_temp_separation_margin_container_left.visible = true
	slimaggedon_focus_indicator_left_text_rect.visible = false
	slimaggedon_temp_separation_margin_container_right.visible = true
	slimaggedon_focus_indicator_right_text_rect.visible = false

func _on_flugdrasil_button_focus_entered() -> void:
	map_2_information.visible = true
	flugdrasil_temp_separation_margin_container_left.visible = false
	flugdrasil_focus_indicator_left_text_rect.visible = true
	flugdrasil_temp_separation_margin_container_right.visible = false
	flugdrasil_focus_indicator_right_text_rect.visible = true


func _on_flugdrasil_button_focus_exited() -> void:
	map_2_information.visible = false
	flugdrasil_temp_separation_margin_container_left.visible = true
	flugdrasil_focus_indicator_left_text_rect.visible = false
	flugdrasil_temp_separation_margin_container_right.visible = true
	flugdrasil_focus_indicator_right_text_rect.visible = false


func _on_slimageddon_button_pressed() -> void:
	get_tree().change_scene_to_file("res://library/002_gameplay_concepts/004_level_system/001_SCENE/slimageddon.tscn") 


func _on_flugdrasil_button_pressed() -> void:
	get_tree().change_scene_to_file("res://library/002_gameplay_concepts/004_level_system/001_SCENE/fluggdrassil.tscn")


func _on_go_to_main_menu_button_pressed() -> void:
	map_selection_container.visible = false
	logo_container.visible = true
	main_button_general_container.visible = true
	first_main_button.grab_focus()
	

func set_up_arena_scores() -> void : 
	slimaggedon_max_score_value_label.text = str(GeneralScore.max_scores[0])
	slimaggedon_last_game_score_value_label.text = str(GeneralScore.last_scores[0])
	flugdrasil_max_score_value_label.text = str(GeneralScore.max_scores[1])
	flugdrasil_last_game_score_value_label.text = str(GeneralScore.last_scores[1])


func _on_go_to_main_menu_button_focus_entered() -> void:
	quit_focus_indicator_left_text_rect.visible = true
	quit_temp_separation_margin_container_left.visible = false
	quit_focus_indicator_right_text_rect.visible = true
	quit_temp_separation_margin_container_right.visible = false


func _on_go_to_main_menu_button_focus_exited() -> void:
	quit_focus_indicator_left_text_rect.visible = false
	quit_temp_separation_margin_container_left.visible = true
	quit_focus_indicator_right_text_rect.visible = false
	quit_temp_separation_margin_container_right.visible = true


func _on_story_mode_focus_entered() -> void:
	story_focus_indicator_left_text_rect.visible = true
	story_temp_separation_margin_container_left.visible = false
	story_focus_indicator_right_text_rect.visible = true
	story_temp_separation_margin_container_right.visible = false


func _on_story_mode_focus_exited() -> void:
	story_focus_indicator_left_text_rect.visible = false
	story_temp_separation_margin_container_left.visible = true
	story_focus_indicator_right_text_rect.visible = false
	story_temp_separation_margin_container_right.visible = true


func _on_arena_mode_focus_entered() -> void:
	arena_focus_indicator_left_text_rect.visible = true
	arena_temp_separation_margin_container_left.visible = false
	arena_focus_indicator_right_text_rect.visible = true
	arena_temp_separation_margin_container_right.visible = false


func _on_arena_mode_focus_exited() -> void:
	arena_focus_indicator_left_text_rect.visible = false
	arena_temp_separation_margin_container_left.visible = true
	arena_focus_indicator_right_text_rect.visible = false
	arena_temp_separation_margin_container_right.visible = true


func _on_quit_game_focus_entered() -> void:
	main_quit_focus_indicator_left_text_rect.visible = true
	main_quit_temp_separation_margin_container_left.visible = false
	main_quit_focus_indicator_right_text_rect.visible = true
	main_quit_temp_separation_margin_container_right.visible = false


func _on_quit_game_focus_exited() -> void:
	main_quit_focus_indicator_left_text_rect.visible = false
	main_quit_temp_separation_margin_container_left.visible = true
	main_quit_focus_indicator_right_text_rect.visible = false
	main_quit_temp_separation_margin_container_right.visible = true
