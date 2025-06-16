extends MeshInstance3D

func _ready():
	var shader_mat := material_override as ShaderMaterial
	if shader_mat:
		var viewport_texture = $PortalViewport.get_texture()
		shader_mat.set_shader_parameter("portal_texture", viewport_texture)
