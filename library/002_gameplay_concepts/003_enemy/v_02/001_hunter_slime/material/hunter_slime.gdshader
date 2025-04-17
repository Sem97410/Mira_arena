shader_type spatial;

uniform sampler2D  noise_texture;
uniform float speed_texture : hint_range(0.0, 1.0, 0.1);
uniform float emission_strength : hint_range(0.0, 1.0, 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV + vec2(TIME * speed_texture,0.0);
	vec3 noise = texture(noise_texture, uv).rgb;
	ALBEDO = noise;
	EMISSION = noise * emission_strength;

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
