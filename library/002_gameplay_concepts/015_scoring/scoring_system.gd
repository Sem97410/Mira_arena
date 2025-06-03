extends Node

#Nodes
@export_group("UI Nodes")
@export_subgroup("General nodes")
@export var reset_counter_label : Label
@export var total_score_label : Label
@export var reset_multiplicator_counter_margin_container : MarginContainer
@export var combo_multiplicator_value_label : Label
@export var player : CharacterBody3D
var wave_manager : WaveManager

@export var score_log_text_label : Label
@export var score_log_number_label : Label

@export var bonus_text_color : Color = Color(0.6, 0.1, 0.1) 
@export var malus_text_color : Color = Color(0.6, 0.1, 0.1)
@export var base_text_color : Color
@export_subgroup("Get point nodes")
@export var bonus_group_point_label : Label
@export var bonus_group_point_multiplicator_label : Label
@export var add_point_group_point_container : HBoxContainer

@export_subgroup("Malus nodes")
@export var log_point_group_point_container : HBoxContainer
@export var malus_group_point_label : Label

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
@export var new_wave_bonus : float 
@export var delay_before_add_points_to_total : float = 3.0
@export var hit_malus_point : float 
@export var death_malus_point : float

var current_multiplicator : int 
var bonus_group_point_value : int

var current_timer_before_add_points_to_total : float 
var total_score_value : int

@export_subgroup("End game")
@onready var stat_labels : Dictionary = {
	"game_over_enemies_killed" : Label,
	"game_over_hits_done" : Label,
	"game_over_hits_received" : Label,
	"game_over_deaths" : Label,
	"game_over_waves_completeds" : Label,
	"game_over_total_score" : Label,
	"victory_enemies_killed" : Label,
	"victory_hits_done" : Label,
	"victory_hits_received" : Label,
	"victory_deaths" : Label,
	"victory_waves_completeds" : Label,
	"victory_total_score" : Label
}

@export var victory_panel : Control
@export var game_over_number_of_enemies_killed_label : Label
@export var game_over_number_of_hits_landed_label : Label
@export var game_over_number_of_hits_taken_label : Label
@export var game_over_number_of_death_label : Label
@export var game_over_number_of_waves_completed_label : Label
@export var game_over_recap_total_score_label : Label
@export var victory_number_of_enemies_killed_label : Label
@export var victory_number_of_hits_landed_label : Label
@export var victory_number_of_hits_taken_label : Label
@export var victory_number_of_death_label : Label
@export var victory_number_of_waves_completed_label : Label
@export var victory_recap_total_score_label : Label

@onready var stats : Dictionary = {
	"game_over_enemies_killed": 0,
	"game_over_hits_done": 0,
	"game_over_hits_received": 0,
	"game_over_deaths": 0,
	"game_over_waves_completeds": 0,
	"victory_enemies_killed": 0,
	"victory_hits_done": 0,
	"victory_hits_received": 0,
	"victory_deaths": 0,
	"victory_waves_completeds": 0
}

#---

@export_subgroup("Signals")
signal player_is_attacking
signal player_kill_enemy(value : int)
signal player_take_damage
signal new_wave_is_launching

#---

@export_subgroup("Debug")
@export var gauge_value_debug_label : Label




# --------------------------------------------------------------------------

# BASE FUNCTIONS

func _ready() -> void:

	stat_labels = {
		"game_over_enemies_killed": game_over_number_of_enemies_killed_label,
		"game_over_hits_done": game_over_number_of_hits_landed_label,
		"game_over_hits_received": game_over_number_of_hits_taken_label,
		"game_over_deaths": game_over_number_of_death_label,
		"game_over_waves_completeds": game_over_number_of_waves_completed_label,

		"victory_enemies_killed": victory_number_of_enemies_killed_label,
		"victory_hits_done": victory_number_of_hits_landed_label,
		"victory_hits_received": victory_number_of_hits_taken_label,
		"victory_deaths": victory_number_of_death_label,
		"victory_waves_completeds": victory_number_of_waves_completed_label
	}
	
	wave_manager = get_tree().get_first_node_in_group("wave_manager")
	player_is_attacking.connect(player_hit_enemies)
	player_kill_enemy.connect(set_up_group_score)
	player_take_damage.connect(player_took_damages)
	new_wave_is_launching.connect(new_wave_scoring_logic)
	
	player.player_is_defeated.connect(set_up_end_game_scoring)
	
	wave_manager.player_win.connect(set_up_end_game_scoring)
	
func _process(delta: float) -> void:
	launch_reset_multiplicator_timer(delta)
	launch_counter_that_add_point_to_total(delta)
	
	set_reset_counter_label()
	update_multiplicator()
	assign_gauge_value_to_label()
	set_up_group_point_multiplicator_label()
	assign_mutliplicator_values_to_label()
	

# --------------------------------------------------------------------------

# MULTIPLICATOR

func launch_reset_multiplicator_timer(delta: float) -> void:
	if time_since_last_hit > 0:
		time_since_last_hit = max(0.0, time_since_last_hit - delta)

		# Affiche le compteur uniquement s’il reste 5 secondes ou moins
		if time_since_last_hit <= 5.0:
			toggle_multiplicator_combo_reset_visibility(true)
		else:
			toggle_multiplicator_combo_reset_visibility(false)

	else:
		# Timer fini → on cache et on reset
		toggle_multiplicator_combo_reset_visibility(false)
		reset_gauge_value()



#---

func launch_timer() -> void : 
	time_since_last_hit = multiplicator_reset_delay

#---

func player_hit_enemies() -> void : 
	launch_timer()
	gauge_multiplicator_value += 1
	
	increment_stat("game_over_hits_done")
	increment_stat("victory_hits_done")

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
	
	increment_stat("game_over_enemies_killed")
	increment_stat("victory_enemies_killed")

	
	bonus_group_point_label.add_theme_color_override("font_color",bonus_text_color)
	
	score_log_number_label.add_theme_color_override("font_color",bonus_text_color)
	score_log_text_label.add_theme_color_override("font_color",bonus_text_color)
	
	
	enable_bonus_visual()
	
	bonus_group_point_value += value
	bonus_group_point_label.text = "+"+ str(bonus_group_point_value)

	
	
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
	handle_total_point_size()
	total_score_label.text = str(total_score_value)
	bonus_group_point_value = 0
	bonus_group_point_label.add_theme_color_override("font_color",base_text_color)
	bonus_group_point_label.text = "+"+ str(bonus_group_point_value)

func set_up_group_point_multiplicator_label() -> void : 
	bonus_group_point_multiplicator_label.text = "X " + str(current_multiplicator)
# --------------------------------------------------------------------------

# MALUS

func player_took_damages() -> void :

	increment_stat("game_over_hits_received")
	increment_stat("victory_hits_received")
	
	flush_group_score()
	score_log_number_label.add_theme_color_override("font_color",malus_text_color)
	score_log_text_label.add_theme_color_override("font_color",malus_text_color)
	
	if player.player_current_hp > 0:
		score_log_text_label.text = "Hit :"
		malus_group_point_label.text = "- " + str(hit_malus_point)
		total_score_value -=  hit_malus_point

	else :
		score_log_text_label.text = "Death :"
		score_log_number_label.text = "- " + str(death_malus_point)
		malus_group_point_label.text = "- " + str(death_malus_point)
		total_score_value -=  death_malus_point
		increment_stat("game_over_deaths")
		increment_stat("victory_deaths")
		
	handle_total_point_size()
	total_score_label.text = str(total_score_value)
	enable_malus_visuals()
	reset_gauge_value()
	
	await get_tree().create_timer(4.0).timeout
	
	reset_text_label()

# --------------------------------------------------------------------------

# BONUS

func new_wave_scoring_logic()-> void : 

	score_log_number_label.add_theme_color_override("font_color",bonus_text_color)
	score_log_text_label.add_theme_color_override("font_color",bonus_text_color)
	
	score_log_text_label.text = "Bonus end wave :"
	score_log_number_label.text = " + " + " " + str(int(new_wave_bonus))
	total_score_value += new_wave_bonus
	increment_stat("game_over_waves_completeds")
	increment_stat("victory_waves_completeds")
	print("victory_waves_completeds : ",  stats["victory_waves_completeds"])
	print("game_over_waves_completeds : ",  stats["game_over_waves_completeds"])
	
	await get_tree().create_timer(4.0).timeout
	
	total_score_label.text = str(total_score_value)
	handle_total_point_size()
	reset_text_label()
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
	log_point_group_point_container.visible = true
	score_log_number_label.visible = true
	malus_group_point_label.visible = true

#---

func reset_text_label() -> void :

	score_log_number_label.text = " "
	score_log_text_label.text = " "
	malus_group_point_label.text = " "

func handle_total_point_size() -> void : 

	if total_score_value >= 1_000_000:
		total_score_label.add_theme_font_size_override("font_size", 30)
	elif total_score_value >= 100_000:
		total_score_label.add_theme_font_size_override("font_size", 40)
	elif total_score_value >= 10_000:
		total_score_label.add_theme_font_size_override("font_size", 50)
	else:
		total_score_label.add_theme_font_size_override("font_size", 60)



func increment_stat(stat_key: String) -> void:
	if stats.has(stat_key) and stat_labels.has(stat_key):
		stats[stat_key] += 1
		stat_labels[stat_key].text = str(stats[stat_key])

func reset_all_stats():
	for key in stats.keys():
		stats[key] = 0
		if stat_labels.has(key):
			stat_labels[key].text = "0"

func set_up_end_game_scoring() -> void : 
	print("Set up end game scoring")
	await get_tree().process_frame # laisse le bonus s'ajouter
	flush_group_score()
	game_over_recap_total_score_label.text = str(total_score_value)
	victory_recap_total_score_label.text = str(total_score_value)
	

	

# --------------------------------------------------------------------------

# DEBUG

func assign_gauge_value_to_label() -> void : 
	gauge_value_debug_label.text = str(gauge_multiplicator_value)
