extends Node

@onready var max_hp : float = 200

@onready var current_hp : float = max_hp

var slime : CharacterBody3D

@onready var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0] 


var knockback_force: float = 30.0
var knockback_velocity: Vector3 = Vector3.ZERO  # Stocker la vitesse du knockback


func _ready() -> void:
	#print("Dummies hp : ", current_hp)
	
	#player = SlimeAutoload.player_pawn
	slime = get_parent()
	
	#print(player)
	#print(slime)
	
func _process(delta: float) -> void:
	
	
	
	destroy_dummies()
	
	if Input.is_action_just_pressed("debug_input"):
		knockback_force = 140.0

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not slime.is_on_floor():
		#dummies.velocity += dummies.get_gravity() * delta
		knockback_velocity.y -= 9.8 * delta * 5  # Simule une gravité manuelle
	#print( slime.is_on_floor())
		
	# Appliquer le knockback et le réduire progressivement
	if knockback_velocity.length() > 0.1:
		slime.velocity = knockback_velocity
		slime.velocity = knockback_velocity  # Appliquer la vélocité
		slime.move_and_slide()
		knockback_velocity = slime.velocity  # Mettre à jour après collision


		# Réduction progressive du knockback
		knockback_velocity = lerp(knockback_velocity, Vector3.ZERO, 10.0 * delta)
	

func take_damage(damage : float) -> void : 
	#print("Ouille")
	#print("Damage is : ", damage)
	current_hp -= damage
	#print("Dummies hp : ", current_hp)
	
	knockback()
	



func destroy_dummies() -> void : 
	if current_hp <= 0 : 
		slime.queue_free()
		
		
func knockback() -> void:
	var direction = (slime.global_position - player.global_position).normalized()
	direction.y = 0  # Neutraliser le déplacement vertical pour la rotation

	# Ajouter le knockback progressif
	knockback_velocity = direction * knockback_force

	# Ajouter une impulsion verticale pour créer l'arc
	knockback_velocity.y = knockback_force * 0.5  # Ajuste ce facteur pour plus ou moins d'arc

	# Regarder dans la direction opposée au joueur
	slime.look_at(slime.global_position - direction)
