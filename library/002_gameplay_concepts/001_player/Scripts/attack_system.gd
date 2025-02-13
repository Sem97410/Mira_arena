extends Node
class_name AttackSystem

var current_damage : float

var light_attack_damage : float

var charged_attack_damage : float 

@export var light_attack_logic : LightAttackAnimationScript
@export var charged_attack_logic : ChargedAttackLogic
@export var camera_shake_logic : CameraShake

@export var light_attack_area : Area3D
@export var long_range_collision_shape : CollisionShape3D
@export var short_range_collision_shape : CollisionShape3D

@export var charged_attack_area : Area3D
@export var charged_attack_collision : CollisionShape3D

@onready var light_damage : float 
@onready var charged_damage: float 


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#enable_light_attack_area()
	light_attack_damage = (100 / 3) + 1 #kill a basic enemy in 3 hits
	charged_attack_damage = 100
	#print("Light attack damage : ", light_attack_damage)
	#print("Charged attack damage : ", charged_attack_damage)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_attack_system_area_3d_area_entered(area: Area3D) -> void:
	make_damage(area , light_attack_damage)


func _on_charged_attack_system_area_3d_area_entered(area: Area3D) -> void:
	print("Attack something from the charged attack")
	make_damage(area, charged_attack_damage)

func make_damage(area : Area3D, damage : float) -> void : 
	# Récupérer le nœud parent de l'Area
	var parent = area.get_parent()
	camera_shake_logic.trigger_shake()
	
	# Trouver le nœud avec la fonction take_damage parmi les frères
	for sibling in parent.get_children():
		if sibling.has_method("take_damage"):
			sibling.take_damage(damage)
			#print("Il a la fonction take_damage")
			break
		else : 
			print("Il n'a pas la fonction")
			
			
func enable_light_attack_area() -> void :
	light_attack_area.monitoring = true

func disable_light_attack_area() -> void :
	light_attack_area.monitoring = false

func enable_long_range_collision() -> void : 
	long_range_collision_shape.disabled = false
	
func disable_long_range_collision() -> void : 
	long_range_collision_shape.disabled = true
	
func enable_short_range_collision() -> void : 
	short_range_collision_shape.disabled = false
	
func disable_short_range_collision() -> void : 
	short_range_collision_shape.disabled = true
	
func enable_charged_attack_area() -> void : 
	charged_attack_area.monitoring = true
	
func disable_charged_attack_area() -> void : 
	charged_attack_area.monitoring = false

func enable_charged_attack_collision() -> void : 
	charged_attack_collision.disabled = false

func disable_charged_attack_collision() -> void : 
	charged_attack_collision.disabled = true

func freeze_frame() -> void : 
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.03).timeout
	Engine.time_scale = 1.0

func set_light_attack_camera_shake_value() -> void : 
	camera_shake_logic.current_shake = camera_shake_logic.light_attack_shake

func set_charged_attack_camera_shake_value() -> void : 
	camera_shake_logic.current_shake = camera_shake_logic.charged_attack_shake
