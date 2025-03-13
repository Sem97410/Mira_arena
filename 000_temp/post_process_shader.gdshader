shader_type spatial;
render_mode unshaded;
//uniform vec3 Color : source_color;
uniform sampler2D depth_texture : hint_depth_texture; // donne accès au depht buffer

void vertex() {

}

void fragment() {
	float depht = texture(depth_texture, SCREEN_UV).r;
	ALBEDO = vec3(pow(depht, 15)) ;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
