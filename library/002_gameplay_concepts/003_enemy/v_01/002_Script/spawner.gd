extends Node3D

@export var spawner_timer: Timer
@export var initial_spawn_count: int = 2  # Nombre d'ennemis au départ
@export var spawn_increase_percent: float = 15.0  # Augmentation en % par vague
@export var spawn_range: float = 5.0  # Rayon autour du spawner
@export var wave_delay: float = 20.0  # Temps d'attente entre deux vagues

@onready var enemies_to_spawn: int = initial_spawn_count  # Nombre d'ennemis à spawn cette vague
@onready var enemies_spawned: int = 0  # Compteur d'ennemis spawnés
@onready var max_enemies_spawned: float = float(initial_spawn_count)  # Utilisation d'un float pour éviter les arrondis bloquants

# Liste des types d'ennemis et leurs probabilités
@export var enemy_types: Array[PackedScene] = []  
@export var spawn_chances: Array[int] = []  

func _on_spawner_timer_timeout() -> void:
	# Vérifie si tous les ennemis de la vague ont été spawnés
	if enemies_spawned >= enemies_to_spawn:
		print("Vague terminée. Attente de", wave_delay, "secondes avant la prochaine vague.")
		spawner_timer.stop()  # Stoppe le timer pour éviter le spam
		get_tree().create_timer(wave_delay).timeout.connect(_restart_spawn_cycle, CONNECT_ONE_SHOT)
		return
	
	# Vérifie la configuration des ennemis
	if enemy_types.is_empty() or spawn_chances.is_empty() or enemy_types.size() != spawn_chances.size():
		print("Erreur : Types d'ennemis et probabilités mal configurés.")
		return

	# Sélectionne un ennemi aléatoire en fonction des probabilités
	var selected_enemy = _choose_enemy_type()

	# Instancie et place l'ennemi dans la scène
	if selected_enemy:
		var new_enemy = selected_enemy.instantiate()
		get_parent().add_child(new_enemy)

		# Position aléatoire autour du spawner
		var random_offset = Vector3(
			randf_range(-spawn_range, spawn_range), 
			0, 
			randf_range(-spawn_range, spawn_range)
		)
		new_enemy.global_position = global_position + random_offset

		# Incrémentation du compteur d'ennemis de la vague
		enemies_spawned += 1
		print("Spawned enemy at:", new_enemy.global_position, " | Progression de la vague :", enemies_spawned, "/", enemies_to_spawn)

# Sélectionne un type d'ennemi en fonction des probabilités
func _choose_enemy_type() -> PackedScene:
	var total_weight = spawn_chances.reduce(func(acc, value): return acc + value, 0)
	var random_pick = randi_range(1, total_weight)
	var accumulated_weight = 0

	for i in range(enemy_types.size()):
		accumulated_weight += spawn_chances[i]
		if random_pick <= accumulated_weight:
			return enemy_types[i]

	return null  # Sécurité, ne devrait pas arriver si les probabilités sont bien réglées

# Augmente le nombre d'ennemis basé sur le **max atteint** et redémarre après un délai
func _restart_spawn_cycle():
	# Augmente progressivement en conservant les décimales
	max_enemies_spawned *= (1 + spawn_increase_percent / 100.0)
	enemies_to_spawn = int(round(max_enemies_spawned))  # Arrondi proprement
	enemies_spawned = 0  # Reset du compteur pour la nouvelle vague

	print("Nouvelle vague !", enemies_to_spawn, "ennemis à spawn.")
	spawner_timer.start()  # Relance proprement le timer pour la prochaine vague
