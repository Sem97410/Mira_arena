@tool
extends Node3D
class_name Spawner

#----------------------

@export_group("❗Required References❗ ⚠️")

@export_subgroup("Nodes")
@export var spawner_timer: Timer
@onready var wave_manager : WaveManager
@export var spawner_placement_indicator : MeshInstance3D
@export var spawner_range_indicator : MeshInstance3D

#----------------------

@export_subgroup("Enemies")
var spawnable_enemies : Array[PackedScene]
var enemy_spawn_list : Array[PackedScene] = [] #Creation of a list that contain every enemies that will spawn in a wave (and not the type of enemy that could spawn)
var enemies_to_spawn: int
var enemies_spawned: int = 0

#----------------------

@export_subgroup("SpawnBehaviors")
@export var spawn_range: float = 5.0  
var is_active := false


#----------------------

@export_subgroup("Debug tools")
@export var spawner_visible_in_game : bool = false

# --------------------------------------------------------------------------

## BASE FUNCTIONS

func _ready():
	if not Engine.is_editor_hint():
		toggle_spawner_visibility(spawner_visible_in_game)

	spawner_timer.stop()
	
	wave_manager = get_tree().get_first_node_in_group("wave_manager")

#---

func _process(_delta):
	if Engine.is_editor_hint(): #If we are in the editor
		_update_spawn_indicator()

# --------------------------------------------------------------------------

## SPAWN BEHAVIOR

#Launch the spawner and active the timer node
func start_spawning(number_to_spawn: int) -> void:  
	enemies_spawned = 0
	enemies_to_spawn = number_to_spawn
	is_active = true
	spawner_timer.start()

#---

func _on_timer_timeout() -> void:  
	
	if enemies_spawned >= enemies_to_spawn: # stop the spawner when reach the wanted number
		spawner_timer.stop()
		is_active = false
		return

	#If we reach the max number of enemies that can spawn in a scene
	if wave_manager.enemies_alive_in_wave >= wave_manager.max_enemies_in_the_scene: 
		return
	
	#Security : if we finish the spawn of every element on enemy_spawn_list
	if enemies_spawned >= enemy_spawn_list.size():
		return

	#Select an enemy in the list of enemy_spawn_list
	var enemy_scene_to_spawn = enemy_spawn_list[enemies_spawned]
	
	
	var new_enemy = enemy_scene_to_spawn.instantiate() #Create an instance of enemy_scene_to_spawn
	get_parent().add_child(new_enemy) #Add it in the scene
	
	#Spawn an enemy in a random range arround the spawner
	new_enemy.global_position = global_position + _random_offset()
	enemies_spawned += 1
	
	##Add an enemy in the wave manager enemies counter
	wave_manager.enemies_alive_in_wave += 1

#---

func _random_offset() -> Vector3:
	return Vector3(
		randf_range(-spawn_range, spawn_range),
		0,
		randf_range(-spawn_range, spawn_range)
	)
	
# --------------------------------------------------------------------------

## SPAWN TOOLS

#Modify the size of the spawn range indicator
func _update_spawn_indicator():
	
	if not is_instance_valid(spawner_placement_indicator):  #Is the object exist  in the scene/ memory
		return

	var mesh := spawner_range_indicator.mesh
	
	if mesh is CylinderMesh:
		mesh.top_radius = spawn_range
		mesh.bottom_radius = spawn_range

#---

#Show or hide the spawner during the game (for debug purpose)
func toggle_spawner_visibility(is_visible : bool) -> void : 
	if is_visible : 
		spawner_placement_indicator.visible = true
		spawner_range_indicator.visible = true
	else : 
		spawner_placement_indicator.visible = false
		spawner_range_indicator.visible = false

#---

func _on_spawn_range_changed(value: float) -> void:
	spawn_range = value
	_update_spawn_indicator()  # ← Update the mesh
