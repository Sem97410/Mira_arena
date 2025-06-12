extends Sprite3D

var minimap : Control
@export var minimap_indicator_close_size : float = 0.6
@export var minimap_indicator_far_size : float = 1.75
@onready var minimap_indicator_close_size_vector : Vector3 = Vector3(minimap_indicator_close_size,minimap_indicator_close_size * 2,minimap_indicator_close_size)
@onready var minimap_indicator_far_size_vector  : Vector3 = Vector3(minimap_indicator_far_size,minimap_indicator_far_size * 2,minimap_indicator_far_size)

func _ready() -> void:
	minimap = get_tree().get_first_node_in_group("minimap")

func _process(delta: float) -> void:
	adapte_indicator_minimap_to_size()

func adapte_indicator_minimap_to_size() -> void : 
	if minimap.is_far_distance :
		self.scale = minimap_indicator_far_size_vector
	else : 
		self.scale = minimap_indicator_close_size_vector
