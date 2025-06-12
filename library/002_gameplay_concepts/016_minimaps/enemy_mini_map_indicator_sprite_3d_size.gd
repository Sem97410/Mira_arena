extends Sprite3D

var minimap : Control
@onready var minimap_indicator_close_size : Vector3 = Vector3(0.6,0.6,0.6)
@onready var minimap_indicator_far_size : Vector3 = Vector3(2.0,2.0,2.0)

func _ready() -> void:
	minimap = get_tree().get_first_node_in_group("minimap")

func _process(delta: float) -> void:
	adapte_indicator_minimap_to_size()

func adapte_indicator_minimap_to_size() -> void : 
	if minimap.is_far_distance :
		self.scale = minimap_indicator_far_size
	else : 
		self.scale = minimap_indicator_close_size
