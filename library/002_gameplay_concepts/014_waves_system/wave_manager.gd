extends Node3D
class_name WaveManager

# --------------------------------------------------------------------------
## Required references

@export_group("❗Required References❗ ⚠️")
@export_subgroup("Manage enemies")
@export var all_enemy_types : Array[PackedScene] #Index 0 and 1 MUST be Wanderer and hunter slime
@export var spawners : Array[Spawner]
@export var initial_number_of_enemies : int
var max_enemies_in_this_wave : int
@export var max_enemies_in_the_scene : int

#----------------------

@export_subgroup("Waves behavior")
@export var wave_cycle_length : int
@export var enemy_count_increase_percentage_per_wave : int = 60
var growth_factor : float = 1.0
@onready var cycle_wave_index = 0
@onready var current_wave : int = 0
@onready var enemies_alive_in_wave : int = 0
@onready var can_change_wave : bool = false
@onready var wave_is_in_progress : bool = false

#----------------------

@export_subgroup("Introduction & break between waves")
@export var cinematic_introduction_length : float = 2.0
@export var pause_after_wave_duration : float = 15.0

#----------------------

@export_subgroup("Statistic")
@onready var enemies_killed_in_this_wave : int = 0

#----------------------

@export_group("Labels")
@export_subgroup("Wave announcement")
@export var max_enemies_in_wave_label  : Label
@export var announce_label : Label
@export var announce_panel : PanelContainer
@onready var visual_timer : float = 0.0

# --------------------------------------------------------------------------
## DEBUGS

@export_subgroup("Debugs")
@export var current_wave_label : Label
@export var enemies_alive_in_wave_label : Label
@export var enemies_killed_in_this_wave_label : Label


# --------------------------------------------------------------------------

## BASE FUNCTIONS

func _ready() -> void:
	launch_map_introduction()
	calculate_growth_factor()

#---

func _process(delta: float) -> void:
	assign_debug_labels_text()
	check_if_can_start_new_wave()
	
	if visual_timer > 0:
		visual_timer -= delta
		
	actualise_anounce_visual_timer()

# --------------------------------------------------------------------------

## WAVES MANAGMENT

func start_wave() -> void : 
	check_if_reset_enemies_count()
	current_wave += 1
	cycle_wave_index += 1
	print("We are in the wave : ", current_wave)
	print("Cycle wave index is : ", cycle_wave_index)
	
	can_change_wave = false 
	wave_is_in_progress = true
	enemies_killed_in_this_wave = 0  # Reset number of enemies killed

	# Calculation of the number of enemies in this wave
	max_enemies_in_this_wave = int(initial_number_of_enemies * pow(growth_factor, cycle_wave_index - 1))
	print("In this wave, we are suppose to have ", max_enemies_in_this_wave, " enemies")	# 20 * pow(2 , 0) =>20
																						#So in this calcule you say that the base number of 
																						#enemies are 20, multiply by a growth factor of 100 % 
																						#in the wave 0 so the result is 20
																						#Same calcule but wave 2 : 
																						# 20 * pow(2 , 1) = 40

	# Equal distrubution between spawners
	var base_count = int(max_enemies_in_this_wave / spawners.size())
	print("Every spawner shound spawns ", base_count, "enemies")
	# 5 / 4 spawners = 1.25 => int = 1
	var rest = max_enemies_in_this_wave % spawners.size()
	# 5 % 4 = 1

	for i in spawners.size():
		var to_spawn = base_count
		if i < rest:
			to_spawn += 1  # Répartit le reste

		spawners[i].start_spawning(to_spawn)  

#---

func prepare_enemies_for_wave() -> void : 
	pass

#---

func check_if_can_start_new_wave() -> void: 
	if can_change_wave and enemies_alive_in_wave  <= 0: 
		start_wave()

#---

func launch_map_introduction() -> void : 
	await get_tree().create_timer(cinematic_introduction_length, false).timeout
	can_change_wave = true

#---

func launch_pause_time_after_wave() -> void : 
	announce_panel.visible = true
	announce_label.text = "Wawe " + str(current_wave) + " : Completed"
	await get_tree().create_timer(2.0, false).timeout
	visual_timer = pause_after_wave_duration
	
	await get_tree().create_timer(pause_after_wave_duration + 1.0, false).timeout
	announce_label.text = "The wave is starting"
	await get_tree().create_timer(2.0, false).timeout
	announce_label.text = "Good luck ..."
	can_change_wave = true
	
	await get_tree().create_timer(2.0, false).timeout
	
	announce_panel.visible = false
	
#---

func calculate_growth_factor() -> void : 
	growth_factor =  1.0 +(enemy_count_increase_percentage_per_wave / 100.0) #1.6*

#---

func reset_enemy_count_for_cycle() -> void :
	max_enemies_in_this_wave = initial_number_of_enemies 
	cycle_wave_index = 0

#---

func check_if_reset_enemies_count() -> void : 
	if cycle_wave_index >= wave_cycle_length:  #cycle_wave_index = what wave in this cycle || wave_cycle_length = number of waves in a cycle
		reset_enemy_count_for_cycle()

# --------------------------------------------------------------------------

## ANNOUNCEMENT

func actualise_anounce_visual_timer() -> void:  
	if visual_timer > 0:
		announce_label.text = "Next wave will start in %.0f" % visual_timer

# --------------------------------------------------------------------------

## DEBUGS

func assign_debug_labels_text() -> void: 
	current_wave_label.text = "Current wave : " + str(current_wave)
	enemies_alive_in_wave_label.text = "Number of enemies in the wave : " + str(enemies_alive_in_wave )
	enemies_killed_in_this_wave_label.text = "Enemies killed in this wave : " + str(enemies_killed_in_this_wave)
	max_enemies_in_wave_label .text = "Number max of enemies in this wave : " + str(max_enemies_in_this_wave)
