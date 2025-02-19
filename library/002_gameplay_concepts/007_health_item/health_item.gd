extends Node3D

@export var health_point : float = 10.0
# Called when the node enters the scene tree for the first time.

func _on_area_3d_area_entered(area: Area3D) -> void:
	#print("Area entered")
	#print("Le nom de l'area est : ", area.name)
	if area.is_in_group("player"):
		
		var health_node = area.get_parent().find_child("HealthComponent", true, false)
		#print("Player max hp is : ",health_node.player_current_hp)
		if health_node.player_current_hp < health_node.player_max_hp :
			health_node.player_current_hp += health_point
			
			if health_node.player_current_hp >= health_node.player_max_hp:
				health_node.player_current_hp = health_node.player_max_hp
				
			health_node.health_bar.health = health_node.player_current_hp

			queue_free()
