extends Node
var number_of_maps : int = 2
var last_scores : Dictionary = {}
var max_scores : Dictionary = {}

func _ready() -> void:
	for i in range(number_of_maps):  # 2 arènes par exemple
		max_scores[i] = 0
		last_scores[i] = 0
