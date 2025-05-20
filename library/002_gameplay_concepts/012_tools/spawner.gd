@tool
extends Node3D
class_name Spawner

@export var spawner_timer: Timer
#@export var enemy_scene: PackedScene
@export var spawnable_enemies : Array[PackedScene]

@export var spawn_range: float = 5.0  

@export var spawner_placement_indicator : MeshInstance3D
@export var spawner_range_indicator : MeshInstance3D

@onready var wave_manager : WaveManager
@export var spawner_visible_in_game : bool = false

var enemy_index : int = 0
#@export var initial_spawn_count: int = 3
#@export var activation_input: String  # Exemple : "launch_hunter"

var enemies_to_spawn: int
var enemies_spawned: int = 0
var is_active := false

func _ready():
	

	if not Engine.is_editor_hint():
		toggle_spawner_visibility(spawner_visible_in_game)
	
	spawner_timer.stop()
	
	wave_manager = get_tree().get_first_node_in_group("wave_manager")


func _process(_delta):
	if Engine.is_editor_hint(): #If we are in the editor
		_update_spawn_indicator()
		

func _update_spawn_indicator():
	
	if not is_instance_valid(spawner_placement_indicator):  #Is the object exist  in the scene/ memory
		return

	var mesh := spawner_range_indicator.mesh
	
	if mesh is CylinderMesh:
		mesh.top_radius = spawn_range
		mesh.bottom_radius = spawn_range

func toggle_spawner_visibility(is_visible : bool) -> void : 
	if is_visible : 
		spawner_placement_indicator.visible = true
		spawner_range_indicator.visible = true
	else : 
		spawner_placement_indicator.visible = false
		spawner_range_indicator.visible = false

func _random_offset() -> Vector3:
	return Vector3(
		randf_range(-spawn_range, spawn_range),
		0,
		randf_range(-spawn_range, spawn_range)
	)

func _on_timer_timeout() -> void:
	if enemies_spawned >= enemies_to_spawn:
		spawner_timer.stop()
		is_active = false  # ← Permet de relancer plus tard avec un autre clic
		return
#
	#if not enemy_scene:
		#return
	
	if wave_manager.enemies_alive_in_wave >= wave_manager.max_enemies_in_the_scene:
		return
	
	if spawnable_enemies.is_empty():    #Security
		return
	
	var enemy_scene_to_spawn = spawnable_enemies[enemy_index] #Select an enemy in the array
	
	enemy_index += 1 
	
	if enemy_index >= spawnable_enemies.size() :
		enemy_index = 0
	

	var new_enemy = enemy_scene_to_spawn.instantiate()
	get_parent().add_child(new_enemy)
	new_enemy.global_position = global_position + _random_offset()
	enemies_spawned += 1
	
	##Add an enemy in the wave manager enemies counter
	wave_manager.enemies_alive_in_wave += 1


	#print("🧬 Spawned:", new_enemy.name, "@", new_enemy.global_position)

func start_spawning(number_to_spawn: int) -> void: #enemy_scene_to_use: PackedScene,
	#if not enemy_scene_to_use:
		#push_warning("❌ No enemy scene passed to spawner.")
		#return
#
	#enemy_scene = enemy_scene_to_use
	enemies_spawned = 0
	enemies_to_spawn = number_to_spawn
	is_active = true
	spawner_timer.start()


func _on_spawn_range_changed(value: float) -> void:
	spawn_range = value
	_update_spawn_indicator()  # ← Update the mesh
