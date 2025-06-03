extends Node3D
class_name WaveManager

# --------------------------------------------------------------------------
## Required references

#A REMETTRE LA OU IL FAUT : 
var scoring_system : Node
var player : CharacterBody3D

@export_group("❗Required References❗ ⚠️")
@export_subgroup("Manage enemies")
@export var all_enemy_types : Array[PackedScene] #Index 0 and 1 MUST be Wanderer and hunter slime
var enemy_types_unlock : Array[PackedScene] #All enemies that can be select in order to be spawn

#What percentage of every type of enemies are we allowed to have ( for exemple : 30% max of bomber in a wave)
@export var enemy_spawn_limits : Dictionary = {
	"hunter_slime" : 0.3,
	"wanderer_slime" : 0.2,
	"explosive_slime" : 0.25,
	"missile_slime" : 0.15,
	"mortar_slime" : 0.1
}

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

@export var victory_wave : int

#----------------------

@export_subgroup("Introduction & break between waves")
@export var cinematic_introduction_length : float = 2.0
@export var pause_after_wave_duration : float = 15.0

#----------------------

@export_subgroup("Statistic")
@onready var enemies_killed_in_this_wave : int = 0
@onready var spawners_that_finished_spawning : int = 0
@onready var number_of_spawned_enemy : int = 0






#----------------------

@export_group("Labels")
@export_subgroup("Wave announcement")
@export var max_enemies_in_wave_label  : Label
@export var announce_label : Label
@export var announce_panel : PanelContainer
@onready var visual_timer : float = 0.0


#----------------------

@export_group("Signal")

signal player_win

# --------------------------------------------------------------------------
## DEBUGS

@export_subgroup("Debugs")
@export var current_wave_label : Label
@export var enemies_alive_in_wave_label : Label
@export var enemies_killed_in_this_wave_label : Label


# --------------------------------------------------------------------------

## BASE FUNCTIONS

func _ready() -> void:
	scoring_system = get_tree().get_first_node_in_group("scoring_system")
	player = get_tree().get_first_node_in_group("player")
	launch_map_introduction()
	calculate_growth_factor()
	#player_win.connect()

	
	

	

#---

func _process(delta: float) -> void:
	#print("Number of finish spawner : ", spawners_that_finished_spawning)
	#print("Spawner array size : ", spawners.size())
	#print("Number of spawn ennemy : ", number_of_spawned_enemy)
	assign_debug_labels_text()
	check_if_can_start_new_wave()
	
	if visual_timer > 0:
		visual_timer -= delta
		
	actualise_anounce_visual_timer()
	
	
# --------------------------------------------------------------------------

## WAVES MANAGMENT

func start_wave() -> void : 
	number_of_spawned_enemy = 0
	
	check_if_reset_enemies_count() #Check if we need to reset the wave cycle (ex : after wave 5)
	
	add_base_enemies_into_waves() # Add base enemies (Wander + hunter) into the array enemy_types_unlock
	

	current_wave += 1 #Increment the wave number
	
	cycle_wave_index += 1 #Increment the position in the wave cycle  (A wave cycle = 5 waves )
	
	if current_wave == victory_wave + 1  :
		player_win_arena()
		print("Player win the arena mode")
		return
		
		
	unlock_new_enemy_for_wave()
	
	can_change_wave = false  #Stop from launching  another wave if we are still in a wave
	wave_is_in_progress = true #Indicate that a wave is running (maybe too much with can_change_wave but I wanted to be sure)
	enemies_killed_in_this_wave = 0  # Reset number of enemies killed
	
	#----------------------		Still in start_wave function	----------------------#
	# Calculation of the number of enemies in this wave
	
	max_enemies_in_this_wave = int(initial_number_of_enemies * pow(growth_factor, cycle_wave_index - 1))
																										# 20 * pow(2 , 0) =>20
																										#So in this calcule you say that the base number of 
																										#enemies are 20, multiply by a growth factor of 100 % 
																										#in the wave 0 so the result is 20
																										#Same calcule but wave 2 : 
																										# 20 * pow(2 , 1) = 40

	#----------------------		Still in start_wave function	----------------------#
	
	# Preparation of the type of enemies that we will have in this wave.
	var enemies_for_this_wave: Array[PackedScene] = generate_enemy_spawn_list(max_enemies_in_this_wave)


	
	#----------------------		Still in start_wave function	----------------------#
	
	# Equal distrubution between spawners
	var base_count = int(max_enemies_in_this_wave / spawners.size())

	# 5 / 4 spawners = 1.25 => int = 1
	var rest = max_enemies_in_this_wave % spawners.size()
	# 5 % 4 = 1

	#----------------------		Still in start_wave function	----------------------#
	for i in spawners.size():
		var to_spawn = base_count
		if i < rest:
			to_spawn += 1  # Répartit le reste

		# 🔹 Donner la liste des ennemis valides au spawner
		spawners[i].enemy_spawn_list = enemies_for_this_wave.duplicate()

		spawners[i].start_spawning(to_spawn)  
		print("Launch of the spawn")
		spawners_that_finished_spawning = 0


#---

#func prepare_enemies_for_wave(wave_number: int) -> Array[PackedScene]: 
	#pass

#---

func check_if_can_start_new_wave() -> void:

	if spawners_that_finished_spawning == spawners.size() : 

		print("Je devrais commencer a vérifier now")

		if can_change_wave and enemies_killed_in_this_wave == number_of_spawned_enemy:
			print("Normalement ca lance une new vague")
			start_wave()

#---

func launch_map_introduction() -> void : 
	await get_tree().create_timer(cinematic_introduction_length, false).timeout
	can_change_wave = true
	start_wave()

#---

func launch_pause_time_after_wave() -> void : 
	announce_panel.visible = true
	announce_label.text = "Wawe " + str(current_wave) + " : Completed"

	#Add bonus point at the end of the current wave
	if current_wave > 0:
		scoring_system.new_wave_is_launching.emit()
		
	if current_wave == victory_wave :
		announce_panel.visible = false
		
		await get_tree().create_timer(2.5).timeout
		can_change_wave = true
		return
		
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


#---

func prepare_spawnable_enemy_types(target_array : Array[PackedScene])-> void : 
	target_array.clear()
	target_array.append_array(enemy_types_unlock)

#---

func unlock_new_enemy_for_wave() -> void:
	
	# We only unlock new enemies starting from wave 2 (cycle_wave_index > 1)
	if cycle_wave_index <= 1:

		add_base_enemies_into_waves()
		return



	# Step 1: Build a list of all the enemies that haven't been unlocked yet
	var remaining_enemies : Array[PackedScene] = []
	
	for enemy in all_enemy_types :
		if not enemy_types_unlock.has(enemy):
			remaining_enemies.append(enemy)
		

	# Step 2: If there are no more enemies left to unlock, do nothing
	if remaining_enemies.is_empty():
	
		return

	# Step 3: Pick one randomly and add it to the unlocked list
	var random_index = randi() % remaining_enemies.size()
	var chosen_enemy = remaining_enemies[random_index]

	enemy_types_unlock.append(chosen_enemy)


#---
#Generate a list of enemies that will be use for the spawner
func generate_enemy_spawn_list(max_enemies: int) -> Array[PackedScene]:
	
	#The list that we will send to spawners that contains every slimes in the wave
	var spawn_list: Array[PackedScene] = []
	
	#The total cumul of every ratio from every unlock enemies
	var total_ratio := 0.0
	
	#Temp dictionary that associate every enemy with it max ratio that are define in enemy_spawn_limits
	var type_ratios: Dictionary[PackedScene, float] = {}

	# Step  1 : get the ratio of every unlock enemies
	for enemy in enemy_types_unlock:
		
		#get the name of every enemies that are in enemy_types_unlock (exemple : wanderer_slime)
		var name := enemy.resource_path.get_file().get_basename()
		
		#If in enemy_spawn_limits there is an entry called wanderer_slime (for exemple wanderer_slime)
		if enemy_spawn_limits.has(name):
			
			#The ratio of this enemy is the ratio that is define for this name entry in enemy_spawn_limits
			var ratio := float(enemy_spawn_limits[name])
			
			#In the temp dictionary type_ratios, you define that, for exemple
			#for the first enemy of the loop that is the wanderer slime, the ratio is 0.3
			type_ratios[enemy] = ratio
			
			#Incrementation of the total ratio of every enemies. We will use this in order to normalise
			total_ratio += ratio

	#Step 2 create a spawn list that respect ratios
	var total_spawned := 0  # <- ✅ AJOUTÉ : pour suivre combien d'ennemis on a réellement ajoutés

	for enemy in type_ratios.keys(): # Go through every key in the dictionary "type_ratios"
		
		 # Normalisation
		var ratio = type_ratios[enemy] / total_ratio # Current ratio for that enemy = base ration of this type of enemy / total of all unlock enemies's ratios
													 # Exemple : there is 3 types of enemies for this wave : Enemy A : 0.3 , Enemy B : 0.7 , Enemy C : 0.8 
													 # So total ratio for this wave : 1.8 => must be 1.0 so normalisation : 
													 # Enemy A final ratio : 0.3 / 1.8 = 0.16 , Enemy B final ratio : 0.7 / 1.8 = 0.38, Enemy C final ratio : 0.7 / 1.8 = 0.44
													 # Total => 0.98 and we round it in order to have 1.0

		#Now we multiply the ratio with the max number in order to have a good number of enemy of this type for this wave
		var count = int(floor(ratio * max_enemies))  # used floor in order to never go beyond the number max of enemies

		#Add the required number of this type of enemy in spawn_list
		for i in range(count):  
			spawn_list.append(enemy)

		total_spawned += count 

	# ✅ need to check if we are not missing some enemies
	var missing = max_enemies - total_spawned
	
	if missing > 0:
		
		#We know that there is not enought enemies in this wave so we recover every enemies that are in type ration
		var unlocked_enemies = type_ratios.keys()
		
		#For every enemy that are missing
		for i in range(missing):
			#Choose in unlocked_enemies un random number and modulo it with unlocked_enemies size that give me an index and then a random enemy to add
			var random_enemy = unlocked_enemies[randi() % unlocked_enemies.size()]
			#Add this random enemy in the list
			spawn_list.append(random_enemy)

	# Step 3 : use the shuffle function in order to mix every element of the enemy list
	spawn_list.shuffle()
	return spawn_list


func player_win_arena() -> void : 
	player_win.emit()
		# --------------------------------------------------------------------------

## ANNOUNCEMENT

func actualise_anounce_visual_timer() -> void:  
	if visual_timer > 0:
		announce_label.text = "Next wave will start in %.0f" % visual_timer

#---


# --------------------------------------------------------------------------

## DEBUGS

func assign_debug_labels_text() -> void: 
	current_wave_label.text = "Current wave : " + str(current_wave)
	enemies_alive_in_wave_label.text = "Number of enemies in the wave : " + str(enemies_alive_in_wave )
	enemies_killed_in_this_wave_label.text = "Enemies killed in this wave : " + str(enemies_killed_in_this_wave)
	max_enemies_in_wave_label .text = "Number max of enemies in this wave : " + str(max_enemies_in_this_wave)
