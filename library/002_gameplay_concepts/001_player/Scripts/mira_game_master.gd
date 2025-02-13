extends Node
class_name MiraGameMaster

#----------------------------------
## REFERENCES
#Scripts
@export var light_attack_logic : LightAttackAnimationScript
@export var charged_attack_logic : ChargedAttackLogic
@export var dash_logic : DashLogic
@export var health_logic : HealthSystem

#----------------------------------
## Nodes
@export var player : CharacterBody3D

#----------------------------------
## Tools
var is_alive : bool

#----------------------------------
## Signals
signal player_use_light_attack
signal player_use_charged_attack
signal player_use_dash

func _ready() -> void:
		SlimeAutoload.player_pawn = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	is_alive = health_logic.is_alive
	
	if is_alive == false : 
		return
		
	if Input.is_action_just_pressed("charge_attack"):
		player_use_charged_attack.emit()
		
		
	if Input.is_action_just_pressed("dash") && dash_logic.dash_countdown <= 0:
		player_use_dash.emit()
	
	if Input.is_action_just_pressed("light_attack") :
		player_use_light_attack.emit()
