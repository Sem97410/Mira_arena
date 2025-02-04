extends Node

# -----------------
## REFERENCES
@export var player: CharacterBody3D  # Le joueur
@export var movement_script: PlayerMovementScript  # Le script de mouvement du joueur

# -----------------
## PARAMÈTRES DU DASH
@export var dash_distance: float = 5.0  # La distance du dash
@export var dash_speed: float = 15.0  # La vitesse du dash
@export var dash_duration: float = 0.2  # La durée du dash

# -----------------
## ÉTATS
var is_dashing: bool = false
var dash_direction: Vector3 = Vector3.ZERO  # La direction du dash

# -----------------
## Logique du dash

# Détection du dash via l'entrée
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()

# Appel d'un mouvement spécial dans _physics_process
func _physics_process(delta: float) -> void:
	if is_dashing:
		execute_dash(delta)

# -----------------
# Démarrer le dash
func start_dash() -> void:
	is_dashing = true
	#movement_script.can_move = false  # Empêcher le contrôle du joueur

	# Direction du dash : dans la direction de la caméra ou de l'orientation du joueur
	dash_direction = -player.transform.basis.z  # La direction est devant le joueur

	# Appliquer une vélocité initiale sur le joueur (donner un "boost" en avant)
	player.velocity = dash_direction * dash_speed

	# Attendre la durée du dash avant de remettre le contrôle
	await get_tree().create_timer(dash_duration).timeout

	# Arrêter le dash, réactiver le contrôle du joueur
	player.velocity = Vector3.ZERO
	movement_script.can_move = true
	is_dashing = false

# -----------------
# Exécuter le dash (pendant la durée du dash)
func execute_dash(delta: float) -> void:
	# Appliquer la vélocité pendant toute la durée du dash
	player.move_and_slide()  # Déplacer le joueur
