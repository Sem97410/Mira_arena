shader_type spatial;

render_mode specular_toon;
uniform vec3 color_one : source_color;
uniform sampler2D noise_texture;
uniform float roughness_intensity : hint_range(0.0,1.0);
uniform vec3 player_position;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 noise = texture(noise_texture,UV).xyz;
	ALBEDO = color_one * noise;
	ROUGHNESS = roughness_intensity;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
