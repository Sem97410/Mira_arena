extends Node3D
class_name WaveManager

@onready var current_wave : int = 0
@onready var current_number_of_enemies_in_wave : int = 0
@onready var can_change_wave : bool = false
@export var cinematic_introduction_length : float = 2.0
@onready var wave_is_in_progress : bool = false
@onready var enemies_killed_in_this_wave : int = 0
@onready var max_enemies_in_this_wave : int = 15
# --------------------------------------------------------------------------
## DEBUGS
@export var current_wave_label : Label
@export var number_of_enemies_in_wave_label : Label
@export var enemies_killed_in_this_wave_label : Label

# --------------------------------------------------------------------------

## BASE FUNCTIONS

func _ready() -> void:
	launch_map_introduction()

#---

func _process(delta: float) -> void:
	assign_debug_labels_text()
	check_if_can_start_new_wave()

# --------------------------------------------------------------------------

## WAVES MANAGMENT

func start_wave() -> void : 
	
	current_wave += 1
	can_change_wave = false
	wave_is_in_progress = true
	enemies_killed_in_this_wave = 0


#---

func end_wave() -> void : 
	pass

#---

func check_if_can_start_new_wave() -> void: 
	if can_change_wave and current_number_of_enemies_in_wave <= 0: 
		start_wave()
	
func launch_map_introduction() -> void : 
	await get_tree().create_timer(cinematic_introduction_length).timeout
	can_change_wave = true
# --------------------------------------------------------------------------

## DEBUGS

func assign_debug_labels_text() -> void: 
	current_wave_label.text = "Current wave : " + str(current_wave)
	number_of_enemies_in_wave_label.text = "Number of enemies in the wave : " + str(current_number_of_enemies_in_wave)
	enemies_killed_in_this_wave_label.text = "Enemies killed in this wave label " + str(enemies_killed_in_this_wave)
