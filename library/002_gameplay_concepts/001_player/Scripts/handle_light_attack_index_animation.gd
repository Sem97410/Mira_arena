extends Node
class_name FightAnimationIndex

@export var base_reset_countdown : float = 1.0

@onready var animation_index: int = 1
@onready var current_reset_countdown: float = 0.0
@onready var combo_active: bool = false
@onready var is_waiting_for_next_combo: bool = false
@onready var buffered_combo: bool = false

@export var animation_player : AnimationPlayer

@onready var combo_lock_timer := 0.0


func _process(delta: float) -> void:
	if combo_lock_timer > 0:
		combo_lock_timer -= delta
	decrease_countdown(delta)
	handle_reset_animation_combo_index()


func request_combo() -> int:
	if combo_lock_timer > 0:
		print("⛔ Combo bloqué, trop rapide")
		return animation_index

	if is_waiting_for_next_combo:
		buffered_combo = true
		print("🕒 Combo en attente (buffered)")
		return animation_index

	var temp_index = animation_index
	increment_index_animation()
	clamp_animation_index()
	combo_active = true
	is_waiting_for_next_combo = true

	combo_lock_timer = 0.2  # ← Ajoute un petit délai anti-spam
	return temp_index



func confirm_combo_done() -> void:
	print("✅ Animation finie, combo débloqué")
	is_waiting_for_next_combo = false

	# Redémarre le reset timer
	launch_countdown()

	if buffered_combo:
		print("▶️ Combo buffered exécuté")
		buffered_combo = false
		request_combo()



func increment_index_animation() -> void:
	animation_index += 1

func clamp_animation_index() -> void:
	if animation_index > 3:
		reset_animation_index()
		print("🔄 Combo reset (trop haut)")

func reset_animation_index():
	print("🧨 RESET combo depuis handle_reset_animation_combo_index()")
	animation_index = 1
	combo_active = false
	is_waiting_for_next_combo = false
	buffered_combo = false

func launch_countdown():
	current_reset_countdown = base_reset_countdown
	print("⏱️ Timer lancé : ", base_reset_countdown, "s")


func decrease_countdown(delta: float):
	if current_reset_countdown > 0:
		current_reset_countdown -= delta
		#print("⏬ countdown :", current_reset_countdown)


func handle_reset_animation_combo_index() -> void:
	if current_reset_countdown <= 0 and combo_active:
		reset_animation_index()
