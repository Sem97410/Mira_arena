extends Node3D

@export var animation_player : AnimationPlayer
@export var mesh_projectil : MeshInstance3D
@export var projectil_explosion_area : Area3D

func _ready() -> void:

	animation_player.play("impact")
	
	
func hide_projectile() -> void : 
	mesh_projectil.visible = false

func destroy_projectil() -> void : 
	self.queue_free()


func _on_area_3d_area_entered(_area: Area3D) -> void:
	make_projectile_zone_damages(projectil_explosion_area, 25.0)
	
	
	
func make_projectile_zone_damages(attack_area : Area3D, damage : float) -> void:
	for area in attack_area.get_overlapping_areas():
		var parent = area.get_parent()

		# ⚠️ Filtrage : on ne touche que les trucs dans le groupe "player"
		if not parent.is_in_group("player"):
			continue


		if parent.has_method("take_damage"):
			parent.take_damage(damage)

		for child in parent.get_children():
			if child.has_method("take_damage"):
				child.take_damage(damage)
				break  # Stop dès qu’un enfant a été touché
