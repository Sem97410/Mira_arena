extends Node3D
class_name Spawner

@export var spawner_timer: Timer
@export var enemy_scene: PackedScene
@export var spawn_range: float = 5.0
@export var initial_spawn_count: int = 3
@export var activation_input: String  # Exemple : "launch_hunter"
@onready var wave_manager : WaveManager

var enemies_to_spawn: int
var enemies_spawned: int = 0
var is_active := false

func _ready():
	spawner_timer.stop()
	wave_manager = get_tree().get_first_node_in_group("wave_manager")

#func _process(_delta):
	#if not is_active and Input.is_action_just_pressed(activation_input):
		##print("✅ Spawner ACTIVATED by input:", activation_input)
		#is_active = true
		#enemies_spawned = 0
		#enemies_to_spawn = initial_spawn_count
		#spawner_timer.start()


func _random_offset() -> Vector3:
	return Vector3(
		randf_range(-spawn_range, spawn_range),
		0,
		randf_range(-spawn_range, spawn_range)
	)


func _on_timer_timeout() -> void:
	if enemies_spawned >= enemies_to_spawn:
		#print("🛑 Spawner finished.")
		spawner_timer.stop()
		is_active = false  # ← Permet de relancer plus tard avec un autre clic
		return

	if not enemy_scene:
		#print("⚠️ No enemy scene assigned!")
		return

	var new_enemy = enemy_scene.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position + _random_offset()
	enemies_spawned += 1
	
	##Add an enemy in the wave manager enemies counter
	wave_manager.current_number_of_enemies_in_wave += 1


	#print("🧬 Spawned:", new_enemy.name, "@", new_enemy.global_position)

func start_spawning(enemy_scene_to_use: PackedScene, number_to_spawn: int) -> void:
	if not enemy_scene_to_use:
		push_warning("❌ No enemy scene passed to spawner.")
		return

	enemy_scene = enemy_scene_to_use
	enemies_spawned = 0
	enemies_to_spawn = number_to_spawn
	is_active = true
	spawner_timer.start()
