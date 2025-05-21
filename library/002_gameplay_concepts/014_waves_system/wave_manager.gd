extends Node3D
class_name WaveManager

# --------------------------------------------------------------------------
## Required references

@export_group("❗Required References❗ ⚠️")
@export_subgroup("Manage enemies")
@export var all_enemy_types : Array[PackedScene] #Index 0 and 1 MUST be Wanderer and hunter slime
var enemy_types_unlock : Array[PackedScene] #All enemies that can be select in order to be spawn

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
	
	check_if_reset_enemies_count() #Check if we need to reset the wave cycle (ex : after wave 5)
	
	add_base_enemies_into_waves() # Add base enemies (Wander + hunter) into the array enemy_types_unlock
	

	current_wave += 1 #Increment the wave number
	
	cycle_wave_index += 1 #Increment the position in the wave cycle  (A wave cycle = 5 waves )
	
	unlock_new_enemy_for_wave()
	
	can_change_wave = false  #Stop from launching  another wave if we are still in a wave
	wave_is_in_progress = true #Indicate that a wave is running (maybe too much with can_change_wave but I wanted to be sure)
	enemies_killed_in_this_wave = 0  # Reset number of enemies killed
	
	#----------------------		Still in start_wave function	----------------------#
	# Calculation of the number of enemies in this wave
	
	max_enemies_in_this_wave = int(initial_number_of_enemies * pow(growth_factor, cycle_wave_index - 1))
	print("In this wave, we are suppose to have ", max_enemies_in_this_wave, " enemies")	# 20 * pow(2 , 0) =>20
																							#So in this calcule you say that the base number of 
																							#enemies are 20, multiply by a growth factor of 100 % 
																							#in the wave 0 so the result is 20
																							#Same calcule but wave 2 : 
																							# 20 * pow(2 , 1) = 40
	#----------------------		Still in start_wave function	----------------------#
	
	# Preparation of the type of enemies that we will have in this wave.
	var enemies_for_this_wave: Array[PackedScene] = []
	prepare_spawnable_enemy_types(enemies_for_this_wave) # Make a copy of the enemies in the enemy_types_unlock to enemies_for_this_wave in the spawners
	
	#----------------------		Still in start_wave function	----------------------#
	
	# Equal distrubution between spawners
	var base_count = int(max_enemies_in_this_wave / spawners.size())
	print("Every spawner shound spawns ", base_count, "enemies")
	# 5 / 4 spawners = 1.25 => int = 1
	var rest = max_enemies_in_this_wave % spawners.size()
	# 5 % 4 = 1

	#----------------------		Still in start_wave function	----------------------#
	for i in spawners.size():
		var to_spawn = base_count
		if i < rest:
			to_spawn += 1  # Répartit le reste

		# 🔹 Donner la liste des ennemis valides au spawner
		spawners[i].spawnable_enemies = enemies_for_this_wave.duplicate()

		spawners[i].start_spawning(to_spawn)  


#---

#func prepare_enemies_for_wave(wave_number: int) -> Array[PackedScene]: 
	#pass

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

#---

func add_base_enemies_into_waves() -> void : 
	enemy_types_unlock.append(all_enemy_types[0])
	enemy_types_unlock.append(all_enemy_types[1])
	print("Add basic enemy")

#---

func prepare_spawnable_enemy_types(target_array : Array[PackedScene])-> void : 
	target_array.clear()
	target_array.append_array(enemy_types_unlock)

#---

func unlock_new_enemy_for_wave() -> void:
	
	# We only unlock new enemies starting from wave 2 (cycle_wave_index > 1)
	if cycle_wave_index <= 1:
		print("We didn't unlock new enemies")
		add_base_enemies_into_waves()
		return

	print("We unlock new enemies")

	# Step 1: Build a list of all the enemies that haven't been unlocked yet
	var remaining_enemies : Array[PackedScene] = []
	
	for enemy in all_enemy_types :
		if not enemy_types_unlock.has(enemy):
			remaining_enemies.append(enemy)
			print("Ennemies in remaining enemies are ", remaining_enemies)

	# Step 2: If there are no more enemies left to unlock, do nothing
	if remaining_enemies.is_empty():
		print("No more enemies left to unlock.")
		return

	# Step 3: Pick one randomly and add it to the unlocked list
	var random_index = randi() % remaining_enemies.size()
	var chosen_enemy = remaining_enemies[random_index]

	enemy_types_unlock.append(chosen_enemy)
	print("🟢 Unlocked new enemy: ", chosen_enemy)

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
