extends Node3D

@export var indication_label : Label3D
@export var health_point : float = 15.0
@export var health_potion_mesh: Node3D
var player : CharacterBody3D
var wave_manager : WaveManager
@onready var potion_was_used : bool = false 
@onready var player_is_in_health_zone : bool = false
@export var health_indicator_minimap : Sprite3D
@export var health_item_visual_effect : Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	wave_manager = get_tree().get_first_node_in_group("wave_manager")
	wave_manager.reset_wave_cycle.connect(reset_health_item)

func _process(delta: float) -> void:
	if indication_label.visible and Input.is_action_just_pressed("light_attack") and not potion_was_used:
		activate_health_potion()

	change_label_text()
	handle_label_visibility()

		


	
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		player_is_in_health_zone = true
		
		
	


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		player_is_in_health_zone = false

	
	


func handle_label_visibility() -> void : 
	if player_is_in_health_zone == true: 
		indication_label.visible = true
	else : 
		indication_label.visible = false

func activate_health_potion() -> void : 
	if player.player_current_hp == player.player_max_hp : 
		indication_label.text = "Too much HP to use potion"
		await get_tree().create_timer(1.5).timeout
		indication_label.text = "Press [X] to use potion"
		return
	indication_label.text = " +" + str(health_point) + "HP"
	health_potion_mesh.visible = false
	health_item_visual_effect.visible = false
	health_indicator_minimap.visible = false
	
	player.player_current_hp += health_point
	player.health_bar.health = player.player_current_hp
	potion_was_used = true
	
	await get_tree().create_timer(2.0).timeout
	indication_label.text =  "Available in "+ str(6 - wave_manager.current_wave) + " waves"

func reset_health_item() -> void : 
	potion_was_used = false
	health_potion_mesh.visible = true
	health_item_visual_effect.visible = true
	health_indicator_minimap.visible = true
	indication_label.text = "Press [X] to use potion"

func change_label_text()  -> void : 
	if potion_was_used == true : 
		await get_tree().create_timer(2.0).timeout
		indication_label.text =  "Available in "+ str(6 - wave_manager.current_wave) + " waves"
