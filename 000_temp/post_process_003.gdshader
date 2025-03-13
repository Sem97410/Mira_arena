shader_type spatial;
render_mode unshaded;
uniform sampler2D depht_texture : hint_depth_texture;


void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	float depht = texture(depht_texture, UV).r;
	ALBEDO = vec3(depht);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
