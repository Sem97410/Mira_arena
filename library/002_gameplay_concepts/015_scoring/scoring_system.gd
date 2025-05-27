extends Node

#Nodes
@export_group("UI Nodes")
@export_subgroup("General nodes")
@export var reset_counter_label : Label
@export var total_score_label : Label
@export var reset_multiplicator_counter_margin_container : MarginContainer
@export var combo_multiplicator_value_label : Label
@export var player : CharacterBody3D

@export_subgroup("Get point nodes")
@export var bonus_group_point_label : Label
@export var bonus_group_point_multiplicator_label : Label
@export var add_point_group_point_container : HBoxContainer

@export_subgroup("Malus nodes")
@export var remove_point_group_point_container : HBoxContainer
@export var malus_group_point_label : Label
@export var malus_group_text_label : Label
@export var malus_number_label : Label


#---
@export_group("Scoring Stats")
@export_subgroup("Scoring values")
@export var multiplicator_reset_delay : float = 5.0
@onready var time_since_last_hit  : float = 0.0
@onready var gauge_multiplicator_value : int = 0
@export var multiplicator_levels : Dictionary = {
	20 : 2,
	40 : 3,
	60 : 4,
	70 : 5
}
@export var delay_before_add_points_to_total : float = 3.0
@export var hit_malus_point : float 
@export var death_malus_point : float

var current_multiplicator : int 
var bonus_group_point_value : int

var current_timer_before_add_points_to_total : float 
var total_score_value : int

#---

@export_subgroup("Signals")
signal player_is_attacking
signal player_kill_enemy(value : int)
signal player_take_damage


#---

@export_subgroup("Debug")
@export var gauge_value_debug_label : Label




# --------------------------------------------------------------------------

# BASE FUNCTIONS

func _ready() -> void:
	player_is_attacking.connect(player_hit_enemies)
	player_kill_enemy.connect(set_up_group_score)
	player_take_damage.connect(player_took_damages)

	
func _process(delta: float) -> void:
	launch_reset_multiplicator_timer(delta)
	launch_counter_that_add_point_to_total(delta)
	
	set_reset_counter_label()
	update_multiplicator()
	assign_gauge_value_to_label()
	set_up_group_point_multiplicator_label()
	assign_mutliplicator_values_to_label()
	
	if Input.is_action_just_pressed("Debug_2"):
		launch_timer()

# --------------------------------------------------------------------------

# MULTIPLICATOR

func launch_reset_multiplicator_timer(delta : float) -> void : 
	if time_since_last_hit > 0:
		toggle_multiplicator_combo_reset_visibility(true)
		time_since_last_hit -= delta
	else :
		toggle_multiplicator_combo_reset_visibility(false)
		reset_gauge_value()

#---

func launch_timer() -> void : 
	time_since_last_hit = multiplicator_reset_delay

#---

func player_hit_enemies() -> void : 
	launch_timer()
	gauge_multiplicator_value += 1

#---

func reset_gauge_value() -> void : 
	gauge_multiplicator_value = 0

#---

func update_multiplicator() -> void : 
	current_multiplicator = 1
	
	for threshold in multiplicator_levels.keys():
		if gauge_multiplicator_value >= threshold:
			current_multiplicator = multiplicator_levels[threshold]
# --------------------------------------------------------------------------

# KILLPOINTS

func set_up_group_score(value : int) -> void : 
	enable_bonus_visual()
	bonus_group_point_value += value
	bonus_group_point_label.text = "+"+ str(bonus_group_point_value)
	malus_number_label.visible = false
	
	
	set_up_group_point_counter()

func set_up_group_point_counter() -> void:
	current_timer_before_add_points_to_total = delay_before_add_points_to_total

func launch_counter_that_add_point_to_total(delta : float) -> void: 
	if current_timer_before_add_points_to_total > 0 : 
		current_timer_before_add_points_to_total -= delta
		if current_timer_before_add_points_to_total <= 0:
			flush_group_score()

func flush_group_score() -> void : 
	total_score_value += (bonus_group_point_value * current_multiplicator)
	total_score_label.text = str(total_score_value)
	bonus_group_point_value = 0
	bonus_group_point_label.text = "+"+ str(bonus_group_point_value)

func set_up_group_point_multiplicator_label() -> void : 
	bonus_group_point_multiplicator_label.text = "X " + str(current_multiplicator)
# --------------------------------------------------------------------------

# MALUS

func player_took_damages() -> void :
	flush_group_score()
	
	if player.player_current_hp > 0:
		print("It's just a hit")
		malus_group_text_label.text = "Hit :"
		malus_group_point_label.text = "- " + str(hit_malus_point)
		total_score_value -=  hit_malus_point
		



	else :
		print("Suppose to be dead")
		malus_group_text_label.text = "Death :"
		malus_group_point_label.text = "- " + str(death_malus_point)
		total_score_value -=  death_malus_point

	total_score_label.text = str(total_score_value)
	enable_malus_visuals()
	reset_gauge_value()
	
	await get_tree().create_timer(4.0).timeout
	
	disable_malus_visuals()
	


# --------------------------------------------------------------------------

# VISUAL

func set_reset_counter_label() -> void : 
	reset_counter_label.text = str(round(time_since_last_hit * 10) / 10.0) #Decimal

#---

func toggle_multiplicator_combo_reset_visibility(is_visible : bool) -> void : 
	reset_multiplicator_counter_margin_container.visible = is_visible

#---

func assign_mutliplicator_values_to_label() -> void : 
	combo_multiplicator_value_label.text ="X" + str(current_multiplicator)

#---

func enable_bonus_visual() -> void : 
	add_point_group_point_container.visible = true
	
#---

func disable_bonus_visual() -> void : 
	add_point_group_point_container.visible = false

#---

func enable_malus_visuals() -> void :
	remove_point_group_point_container.visible = true
	malus_number_label.visible = true
	malus_group_point_label.visible = true

#---

func disable_malus_visuals() -> void :
	remove_point_group_point_container.visible = false
	malus_number_label.visible = false
	malus_group_point_label.visible = false


# --------------------------------------------------------------------------

# DEBUG

func assign_gauge_value_to_label() -> void : 
	gauge_value_debug_label.text = str(gauge_multiplicator_value)
