extends CharacterBody3D

## A COMMENTER DE OUF JE PIGES RIEN 

const SPEED = 8.0
const JUMP_VELOCITY = 4.5

@export var animation_tree: AnimationTree

func _physics_process(delta: float) -> void:
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= 9.8 * delta  

	# Gestion du saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Récupération de l'input du joueur
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = Vector3(input_dir.x, 0, input_dir.y).normalized()
	var input_strength: float = input_dir.length()  # 🔥 Intensité du joystick (0 à 1)

	# **Utilisation mixte : Root Motion + Inputs**
	var root_motion := animation_tree.get_root_motion_position()  # Récupérer le déplacement de l'animation

	if direction.length() > 0.1:  # **Évite les mouvements parasites**
		velocity.x = (direction.x * SPEED * input_strength) + root_motion.x
		velocity.z = (direction.z * SPEED * input_strength) + root_motion.z

		# **Appliquer une rotation propre sans bug**
		rotate_character(direction, delta)
	else:
		# Si pas de direction donnée, garder uniquement le Root Motion
		velocity.x = root_motion.x
		velocity.z = root_motion.z

	# Appliquer le mouvement
	move_and_slide()

	# **Mettre à jour le Blend Position**
	set_blend_position_amount(input_strength)
	print("Blend_amount : ", animation_tree["parameters/StateMachine/BlendSpace1D/blend_position"])
	print("Velocity : ", velocity)

func rotate_character(direction: Vector3, delta: float) -> void:
	var target_rotation: Basis = Basis.looking_at(direction, Vector3.UP)  # **Garde l’axe Y droit**
	transform.basis = transform.basis.slerp(target_rotation, 10 * delta)  # **Rotation fluide et naturelle**

func set_blend_position_amount(input_strength: float) -> void:
	animation_tree.set("parameters/StateMachine/BlendSpace1D/blend_position", velocity.length())
