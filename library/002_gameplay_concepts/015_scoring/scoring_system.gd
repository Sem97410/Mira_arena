extends Node

#Nodes
@export_group("❗Required References❗ ⚠️")
@export_subgroup("UI nodes")
@export var reset_counter_label : Label
@export var total_score_label : Label
@export var group_point_label : Label
@export var reset_multiplicator_counter_margin_container : MarginContainer
@export var combo_multiplicator_value_label : Label
@export var group_point_multiplicator_label : Label
@export var add_point_group_point_container : HBoxContainer
@export var remove_point_group_point_container : HBoxContainer
@export var malus_group_point_label : Label
@export var malus_number_label : Label

var player : CharacterBody3D

#---

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
@export var hit_malus_point : float 
var current_multiplicator : int 
var group_point_value : int
@export var delay_before_add_points_to_total : float = 3.0
var current_timer_before_add_points_to_total : float 
var total_score_value : int

#---

@export_subgroup("Signals")
signal player_is_attacking
signal enemy_is_dead(value : int)
signal player_take_damage
signal player_is_dead

#---

@export_subgroup("Debug")
@export var gauge_value_debug_label : Label




# --------------------------------------------------------------------------

# BASE FUNCTIONS

func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player") #Assign the player
	player_is_attacking.connect(player_hit_enemies)
	enemy_is_dead.connect(set_up_group_score)
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
	disable_remove_point_container()
	group_point_value += value
	group_point_label.text = "+"+ str(group_point_value)
	
	set_up_group_point_counter()

func set_up_group_point_counter() -> void:
	current_timer_before_add_points_to_total = delay_before_add_points_to_total

func launch_counter_that_add_point_to_total(delta : float) -> void: 
	if current_timer_before_add_points_to_total > 0 : 
		current_timer_before_add_points_to_total -= delta
		if current_timer_before_add_points_to_total <= 0:
			flush_group_score()

func flush_group_score() -> void : 
	total_score_value += (group_point_value * current_multiplicator)
	total_score_label.text = str(total_score_value)
	group_point_value = 0
	group_point_label.text = "+"+ str(group_point_value)

func set_up_group_point_multiplicator_label() -> void : 
	group_point_multiplicator_label.text = "X " + str(current_multiplicator)
# --------------------------------------------------------------------------

# MALUS

func player_took_damages() -> void :
	flush_group_score()
	enable_remove_point_container()
	malus_group_point_label.text = "- " + str(hit_malus_point)
	
	reset_gauge_value()
	
	

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

func enable_remove_point_container() -> void : 
	add_point_group_point_container.visible = false
	remove_point_group_point_container.visible = true
	
#---

func disable_remove_point_container() -> void :
	add_point_group_point_container.visible = true
	remove_point_group_point_container.visible = false
# --------------------------------------------------------------------------

# DEBUG

func assign_gauge_value_to_label() -> void : 
	gauge_value_debug_label.text = str(gauge_multiplicator_value)
