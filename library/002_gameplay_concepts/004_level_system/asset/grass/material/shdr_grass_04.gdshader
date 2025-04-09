shader_type spatial;

render_mode cull_disabled;
uniform sampler2D Gradient ;
uniform vec3 color_one : source_color; // colo_01
uniform vec3 color_two : source_color; // colo_02
uniform float min_height = 0.0; // La base de ton mesh
uniform float max_height = 1.0; // La hauteur max du mesh
uniform float wind_speed;
uniform float wind_intensity;

varying float height_blend;
void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX , 1.0)).xyz;
	float axe_y = world_pos.y;
	float wind_weight = clamp(axe_y /2.0 ,0.0,1.0); // Le poids du vent, selon la hauteur
	float wind_strength = sin(TIME + world_pos.x * wind_speed);
	VERTEX.x += wind_strength * wind_weight * wind_intensity;


		// On récupère la position verticale du vertex
	height_blend = clamp((VERTEX.y - min_height) / (max_height - min_height), 0.0, 1.0);// affecter les couleur de fragment au vertex
}

void fragment() {
	//vec3 gradient = texture(Gradient, UV).xyz;
	vec3 final_color = mix(color_one, color_two, height_blend);
	ALBEDO = final_color;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
