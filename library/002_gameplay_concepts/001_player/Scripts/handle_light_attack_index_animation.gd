extends Node

class_name FightAnimationIndex
#----------------------------------

@export var base_reset_countdown : float = 1.5

@onready var animation_index : int = 1
@onready var current_reset_countdown : float = 0.0
@onready var combo_active : bool = false
@onready var is_waiting_for_next_combo : bool = false
@onready var buffered_combo : bool = false

func _process(delta: float) -> void:
	decrease_countdown(delta)
	handle_reset_animation_combo_index()

#-------------------------------------------------
func request_combo() -> int:
	# Si l’anim est encore en cours, on buffer l’intention
	if is_waiting_for_next_combo:
		buffered_combo = true
		print("Combo request buffered for next")
		return animation_index  # ne change pas encore

	# Sinon on autorise le passage à l’attaque suivante
	var temp_index = animation_index
	increment_index_animation()
	clamp_animation_index()
	launch_countdown()
	combo_active = true
	is_waiting_for_next_combo = true
	return temp_index

func confirm_combo_done() -> void:
	is_waiting_for_next_combo = false

	# Si un combo est en attente → on le joue maintenant
	if buffered_combo:
		buffered_combo = false
		request_combo()

#-------------------------------------------------
func increment_index_animation() -> void:
	animation_index += 1

func clamp_animation_index() -> void:
	if animation_index > 3:
		reset_animation_index()
		print("Combo reset! Clamp")

func reset_animation_index() -> void:
	animation_index = 1
	combo_active = false
	is_waiting_for_next_combo = false
	buffered_combo = false

func launch_countdown() -> void:
	current_reset_countdown = base_reset_countdown

func decrease_countdown(delta: float) -> void:
	if current_reset_countdown > 0:
		current_reset_countdown -= delta

func handle_reset_animation_combo_index():
	if current_reset_countdown <= 0 and combo_active:
		reset_animation_index()
		print("Combo reset! < 0")
