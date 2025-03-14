shader_type spatial;
render_mode unshaded;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D noise_texture ;
uniform float effect_thresold = 0.5; 
uniform float paint_variation_intensity;
uniform float alpha_intensity : hint_range(0.0, 1.0, 0.1);
uniform float distorsion_strenght;


void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	//float depth = texture(depth_texture, SCREEN_UV).x;
	//vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	//ALBEDO = vec3(depth); // Affiche la profondeur en niveaux de gris
	
	float base_depth = texture(depth_texture, SCREEN_UV).r;
	float linear_depth = 1.0 / (base_depth * 10.0 + 1.0);
	vec3 screen_color = texture(screen_texture,SCREEN_UV).rgb;
	vec3 noise = texture(noise_texture, SCREEN_UV).rgb;
	vec2 distorded_uv = SCREEN_UV + (noise - 0.5).rg * distorsion_strenght;
	distorded_uv = clamp(distorded_uv,vec2(0.0), vec2(1.0));
	vec3 distorded_color = texture(screen_texture, distorded_uv).rgb;
	float effect_strength = smoothstep(0.0,effect_thresold,linear_depth);
	//vec3 paint_effect = mix(screen_color,screen_color + (noise - 0.5) * paint_variation_intensity, effect_strength);
	vec3 paint_effect = mix(screen_color,distorded_color, effect_strength);
	ALBEDO = paint_effect;
	ALPHA = alpha_intensity;

	

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
