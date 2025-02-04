extends Node

# -----------------
## REFERENCES
@export var player: CharacterBody3D  # Le joueur
@export var movement_script: PlayerMovementScript  # Le script de mouvement du joueur
@export var dash_speed: float = 10.0
@export var dash_duration: float = 0.2
var dash_progress: float = 0.0
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO

func _process(delta):
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()

func _physics_process(delta):
	if is_dashing:
		execute_dash(delta)
	player.move_and_slide()

func start_dash():
	is_dashing = true
	dash_progress = 0.0
	dash_direction = -player.transform.basis.z  # Direction devant le joueur

func execute_dash(delta):
	dash_progress += delta / dash_duration  # Augmente progressivement
	if dash_progress >= 1.0:
		is_dashing = false
		player.velocity = Vector3.ZERO
		return

	# Appliquer `lerp` pour interpoler la vélocité
	player.velocity = player.velocity.lerp(dash_direction * dash_speed, dash_progress)
