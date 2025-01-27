shader_type spatial;

uniform sampler2D  noise_texture  ;
uniform vec3 colorOne : source_color ;
uniform vec3 colorTwo : source_color ;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 noiseTexture = texture(noise_texture,UV).rgb;
	ALBEDO = mix(colorOne,colorTwo,noiseTexture);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
